class View::Qa::TagImage
  include Virtus.model

  attribute :id, Integer

  attribute :url, String
  attribute :wide_stripe_url, String
  attribute :short_stripe_url, String
  attribute :thumb_shadow_url, String
end
