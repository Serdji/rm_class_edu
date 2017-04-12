class View::Qa::User
  include Virtus.model

  attribute :id, Integer
  attribute :anonymous_id, Integer

  attribute :first_name, String
  attribute :last_name, String
  attribute :avatar_url, String
  attribute :gender, String

  attribute :is_sentry, Boolean
end
