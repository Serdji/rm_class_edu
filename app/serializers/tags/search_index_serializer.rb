class Tags::SearchIndexSerializer < ActiveModel::Serializer
  attributes :image_url, :wide_stripe_url,
    :short_stripe_url, :thumb_with_shadow_url

  attribute(:type) { 'tags' }

  attributes :id, :name

  attribute :url do
    Rails.application.routes.url_helpers.tag_path(slug: object.slug)
  end

  attribute :questions_counter, key: :questions_count
  attribute :answers_counter, key: :answers_count

  attribute :is_published do
    object.is_published? && object.questions_counter > 0
  end

  def image_url
    object.image.url
  end

  def wide_stripe_url
    object.image.wide_stripe_url
  end

  def short_stripe_url
    object.image.short_stripe_url
  end

  def thumb_with_shadow_url
    object.image.thumb_shadow_url
  end
end
