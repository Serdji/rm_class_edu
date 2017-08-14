module Qa::Imageable
  extend ActiveSupport::Concern

  included do
    delegate :wide_stripe_url, :short_stripe_url, :thumb_with_shadow_url,
             :thumb_17x17_url, :thumb_24x24_url, :thumb_30x30_url,
             to: :image, allow_nil: true, prefix: true

    delegate :image_url, to: :image, allow_nil: true, prefix: false
  end

  def image
    @image ||= Images::Tag.find_by(imageable_attributes)
  end

  def build_image(attributes = {})
    @image = Images::Tag.new(imageable_attributes(attributes))
  end

  private

  def imageable_attributes(attributes = {})
    attributes.merge(imageable_id: id, imageable_type: self.class)
  end
end
