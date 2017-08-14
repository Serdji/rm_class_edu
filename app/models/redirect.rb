class Redirect < ActiveRecord::Base
  LISTING_TYPES = %w(questions tags).freeze
  RESOURCE_TYPES = %w(question tag).freeze

  REDIRECT_TYPES = LISTING_TYPES | RESOURCE_TYPES

  validates :redirect_type, inclusion: { in: REDIRECT_TYPES }
  validates :entity_type, uniqueness: { scope: :entity_id }

  validates :redirect_id, presence: true, if: -> { RESOURCE_TYPES.include?(redirect_type) }

  before_save do
    self.redirect_id = nil if LISTING_TYPES.include?(redirect_type)
  end

  after_save :hide_question, if: lambda {
    entity_type == 'Qa::Question' && entity.published?
  }

  class << self
    def options_for_select
      {
        destroy: 'Выберите тип',
        questions: 'Лента вопросов (главная)', question: 'Вопрос',
        tags: 'Лента тем', tag: 'Тема'
      }.invert.to_a
    end

    def destroy_for(entity)
      redirect = find_by_entity(entity)
      return unless redirect

      redirect.destroy
    end

    def create_for(entity, params = {})
      create do |o|
        o.entity_type = entity.class
        o.entity_id = entity.id

        o.redirect_type = params[:type]
        o.redirect_id = params[:id]
      end
    end

    def find_by_entity(entity)
      find_by(entity_type: entity.class, entity_id: entity.id)
    end
  end

  def entity
    @entity ||= begin
      klass = entity_type.constantize
      klass.find(entity_id)
    end
  end

  def listing_page?
    redirect_type && !redirect_id
  end

  def resource_page?
    !listing_page?
  end

  def redirect_path
    send "#{redirect_type}_path"
  end

  private

  def questions_path
    Education::Url.send :root_path
  end

  def question_path
    question = Qa::Question.find(redirect_id, include: 'tags')
    question = Front::QuestionDecorator.new(question)
    question.path
  end

  def tags_path
    Education::Url.send :temy_path
  end

  def tag_path
    tag = Qa::Tag.find(redirect_id)
    Education::Url.send :tag_path, slug: tag.slug
  end

  def hide_question
    entity.state = 'hidden'
    entity.save
  end
end
