class View::Qa::Tag
  include Virtus.model
  include ::Qa::Imageable

  class << self
    def get(path, params = {})
      Qa::Client.call(path, self, params)
    end

    def published(params = {})
      params = params.deep_merge(filter: { is_published: true })
      get('tags', params)
    end

    def find(id, options = {})
      get("tags/#{id}", options)
    end
  end

  attribute :id, Integer
  attribute :weight, Integer
  attribute :questions_counter, Integer
  attribute :answers_counter, Integer

  attribute :name, String
  attribute :slug, String

  attribute :is_published, Boolean

  attribute :created_at, DateTime
  attribute :updated_at, DateTime

  alias read_attribute_for_serialization send

  def cache_key
    "tags/#{id}-#{updated_at.utc.to_s(:number)}"
  end

  delegate :title, :keywords, :description, to: :seo, prefix: true, allow_nil: true

  attr_writer :seo, :image

  def seo
    @seo ||= Seo.find_by(seoable_type: 'Qa::Tag', seoable_id: id)
  end

  def image
    @image ||= Image.find_by(imageable_type: 'Qa::Tag', imageable_id: id)
  end
end
