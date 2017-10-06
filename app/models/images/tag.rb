class Images::Tag < Image
  include Loggable

  mount_uploader :image, TagImageUploader

  loggable :all

  def thumb_17x17_url
    image_url(:thumb_17x17)
  end

  def thumb_24x24_url
    image_url(:thumb_24x24)
  end

  def thumb_30x30_url
    image_url(:thumb_30x30)
  end

  def wide_stripe_url
    image_url(:wide_stripe)
  end

  def short_stripe_url
    image_url(:short_stripe)
  end

  def thumb_with_shadow_url
    image_url(:thumb_with_shadow)
  end
end
