class View::Qa::Tag
  include Virtus.model

  class << self
    def get(path, params = {})
      Qa::Client.call(path, self, params)
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

  attribute :image, View::Qa::TagImage

  alias read_attribute_for_serialization send

  def cache_key
    "tags/#{id}-#{updated_at.utc.to_s(:number)}"
  end

  delegate :title, :keywords, :description, to: :seo, prefix: true, allow_nil: true

  def seo
    @seo ||= Seo.find_by(seoable_type: 'Qa::Tag', seoable_id: id)
  end
end
