require 'httparty'

class ImageRemoveJob < ActiveJob::Base
  queue_as :image

  def perform(klass, column, image_url)
    @uploader = klass.constantize.uploaders[column.to_sym]
    @image_url = image_url

    @uploader.webdav_storage? ? remote_remove : local_remove
  end

  private

  def remote_remove
    # TODO: with options we got redirections too deep error
    # options = { headers: { host: @uploader.webdav_host_header } }
    HTTParty.delete(URI.encode(@image_url))
  end

  def local_remove
    encoded_path = URI(URI.encode(@image_url)).path[1..-1]
    path = Rails.root.join('public', URI.decode(encoded_path))
    FileUtils.rm_f(path)
  end
end
