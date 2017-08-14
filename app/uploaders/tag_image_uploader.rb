class TagImageUploader < ImageUploader
  include CarrierWave::Processors::Blur
  include CarrierWave::Processors::ThumbWithShadow

  version :wide_stripe do
    process blurize: { geometry: [580, 5], resize_to: 0.01 }
  end

  version :short_stripe do
    process blurize: { geometry: [280, 5], resize_to: 0.01 }
  end

  version :thumb_with_shadow do
    process with_shadow: {
      geometry: [144, 144], offset_x: 20, offset_y: 30, shadow_offset: 20, blur: [0, 6]
    }
  end

  thumb_version 24, 24
  thumb_version 36, 36

  def class_name
    'image'
  end
end
