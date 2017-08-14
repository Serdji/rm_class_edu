class View::Qa::Question
  include Virtus.model

  PUBLIC_STATES = %w(fresh with_complaints without_complaints).freeze

  class << self
    def get(path, params = {})
      Qa::Client.call(path, self, params)
    end

    def published(params = {})
      params = params.deep_merge(filter: { state: PUBLIC_STATES })
      get('questions', params)
    end

    def find(id, options = {})
      get("questions/#{id}", options)
    end
  end

  attribute :title, String
  attribute :body, String
  attribute :state, String
  attribute :slug, String

  attribute :id, Integer
  attribute :user_id, Integer
  attribute :answers_counter, Integer

  attribute :is_interesting, Boolean
  attribute :has_best_answer, Boolean

  attribute :published_at, DateTime
  attribute :ordered_at, DateTime
  attribute :updated_at, DateTime
  attribute :created_at, DateTime

  attribute :tags, Array[View::Qa::Tag]

  attribute :user, View::Qa::User
  attribute :best_answer, View::Qa::Answer

  alias read_attribute_for_serialization send

  def cache_key
    "questions/#{id}-#{updated_at.utc.to_s(:number)}"
  end

  def published?
    state != 'hidden'
  end

  delegate :title, :keywords, :description, to: :seo, prefix: true, allow_nil: true

  attr_writer :seo

  def seo
    @seo ||= Seo.find_by(seoable_type: 'Qa::Question', seoable_id: id)
  end

  def images
    @images ||= Image.where(imageable_type: 'Qa::Question', imageable_id: id)
  end

  def redirect
    @redirect = Redirect.find_by(entity_type: 'Qa::Question', entity_id: id)
  end
end
