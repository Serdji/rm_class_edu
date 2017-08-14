class Qa::Tag < Qa::Base
  include Qa::Seoable
  include Qa::Imageable

  has_many :linked_tags, class_name: 'Qa::Tag'
  has_many :questions, class_name: 'Qa::Question'

  # TODO: implement it in json api
  # instead of hardcoded scopes
  scope :has_questions, -> { where(has_questions: true) }

  scope :published, -> { where(filter: { is_published: true }) }
  scope :hidden, -> { where(filter: { is_published: false }) }

  class << self
    # TODO: remove this depricated method
    def tags_for_select(additional_tags = nil)
      current = additional_tags ? additional_tags : []
      current = current.map { |t| [t.name, t.id] }

      (all.map { |t| [t.name, t.id] } + current).uniq
    end

    def find_by_slug(slug, params = {})
      get_resource("tags/slug/#{slug}", params) if slug
    end

    def search(search, limit = 7)
      where page: { size: limit }, filter: { name: search }
    end
  end

  loggable :all
  boolean_field :is_published
end
