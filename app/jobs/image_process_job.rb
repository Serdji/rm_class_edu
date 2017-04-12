require 'httparty'

class ImageProcessJob < ActiveJob::Base
  queue_as :image

  class RemoteFile < CarrierWave::Uploader::Download::RemoteFile
    def original_filename
      URI.decode(super)
    end
  end

  class LocalFile < File
    def initialize(uri)
      path = Rails.root.join('public', URI.decode(uri.path[1..-1]))
      super(path)
    end
  end

  class TempImageFile
    attr_reader :strategy

    def initialize(uri)
      @strategy = resolve_strategy.new(uri)
    end

    def method_missing(*args, &block)
      @strategy.send(*args, &block)
    end

    private

    def resolve_strategy
      Rails.env.development? ? LocalFile : RemoteFile
    end
  end

  def perform(id)
    model = Image.find(id)
    image_url = model.temp_image_url

    model.with_lock do
      processed_uri = model.image.process_uri(image_url)
      temp_image_file = TempImageFile.new(processed_uri).strategy

      model.image = temp_image_file
      model.update_attribute(:temp_image_url, nil)
      model.save!
    end

    ImageRemoveJob.perform(model.class.name, 'image', image_url)
  end
end
