class Front::TagsController < Front::ApplicationController
  before_action :check_tag, only: :show

  helper_method :tags_facade

  def index
  end

  def show
    @hide_ban_footer = true

    unless mobile_version?
      @discussing_questions = tags_facade.discussing_questions
    end
  end

  def search
    options = {
      page: { size: 7 }, filter: { is_published: true, name: params[:search] }
    }
    tags = Qa::Tag.where(options)
    render json: tags.collect { |tag| { id: tag.id, name: tag.name } }
  end

  def options
    tags = Qa::Tag.published.all
    render json: tags.map { |tag| { name: tag.name, id: tag.id } }
  end

  private

  def tags_facade
    @tags_facade ||= Front::TagsFacade.new(self)
  end

  def check_tag
    tag = tags_facade.tag
    raise Front::NotFoundError unless tag && tag.published?
  end
end
