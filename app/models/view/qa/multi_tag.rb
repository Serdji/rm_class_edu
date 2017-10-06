class View::Qa::MultiTag
  include Virtus.model

  class << self
    def get(path, params = {})
      Qa::Client.call(path, self, params)
    end
  end

  attribute :id, Integer

  attribute :questions_counter, Integer
  attribute :answers_counter, Integer

  attribute :slug, String
  attribute :tags, Array[View::Qa::Tag]

  attribute :is_published, Boolean

  attribute :created_at, DateTime
  attribute :updated_at, DateTime

  alias read_attribute_for_serialization send

  def cache_key
    # TODO: remove try later
    "multi_tags/#{id}-#{updated_at.utc.to_s(:number)}"
  end

  delegate :title, :keywords, :description, to: :seo, prefix: true, allow_nil: true

  attr_writer :seo

  def seo
    @seo ||= Seo.find_by(seoable_type: 'Qa::MultiTag', seoable_id: id)
  end
end
