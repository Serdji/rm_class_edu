class Tags::SearchIndexSerializer < ActiveModel::Serializer
  attributes :image_url, :wide_stripe_url,
    :short_stripe_url, :thumb_with_shadow_url

  attribute(:type) { 'tags' }

  attributes :id, :name

  attribute :url do
    Education::Url.tag_url(
      slug: object.slug, host: Education::Application.config.domain
    )
  end

  attribute :questions_counter, key: :questions_count
  attribute :answers_counter, key: :answers_count

  attribute :is_published do
    object.is_published? && object.questions_counter > 0
  end

  delegate :image_url, to: :object

  def wide_stripe_url
    object.image_wide_stripe_url
  end

  def short_stripe_url
    object.image_short_stripe_url
  end

  def thumb_with_shadow_url
    object.image_thumb_with_shadow_url
  end
end
