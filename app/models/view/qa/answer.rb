class View::Qa::Answer
  include Virtus.model

  class << self
    def get(path, params = {})
      Qa::Client.call(path, self, params)
    end

    def find(id, options = {})
      get("answers/#{id}", options)
    end
  end

  attribute :id, Integer
  attribute :question_id, Integer
  attribute :user_id, Integer
  attribute :state_number, Integer

  attribute :body, String
  attribute :state, String

  attribute :best_answer, Boolean

  attribute :published_at, DateTime
  attribute :updated_at, DateTime
  attribute :created_at, DateTime

  attribute :user, View::Qa::User

  alias read_attribute_for_serialization send

  def published?
    state != 'hidden'
  end

  def cache_key
    "answers/#{id}-#{updated_at.utc.to_s(:number)}"
  end

  def images
    @images ||= Image.where(imageable_type: 'Qa::Answer', imageable_id: id)
  end
end
