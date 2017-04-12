class Qa::Question
  PUBLIC_STATES = %w(fresh with_complaints without_complaints).freeze

  include Her::JsonApi::Model

  include Seoable

  include Qa::Datable
  include Qa::Relationable
  include Qa::QaSeoable
  include Qa::Errorable

  has_many :tags, class_name: 'Qa::Tag'
  has_many :taggings, class_name: 'Qa::Tagging'

  has_many :answers, class_name: 'Qa::Answer'
  has_many :complaints, class_name: 'Qa::Complaint'

  belongs_to :user, class_name: 'Qa::User'

  # TODO: Scope Her break responsibilty chain
  scope :interesting, -> { where(filter: { is_interesting: true, state: PUBLIC_STATES }) }
  scope :published,   -> { where(filter: { state: PUBLIC_STATES }) }
  scope :hidden,      -> { where(filter: { state: 'hidden' }) }
  scope :with_tags,   -> { where(include: 'tags') }

  class << self
    def options_for_select(additional_id = nil)
      current = additional_id ? [find(additional_id)] : []
      current = current.collect { |t| ["#{t.id} - #{t.title}", t.id] }

      (all.collect { |t| ["#{t.id} - #{t.title}", t.id] } + current).uniq
    end

    def states_for_select
      I18n.t('states.question').invert.to_a
    end
  end

  def tag_ids
    @attributes[:tag_ids] ||= tags.map(&:id)
  end

  def tag_ids=(ids)
    @attributes[:tag_ids] = ids
  end
end
