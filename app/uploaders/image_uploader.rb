class ImageUploader < CarrierWave::Uploader::Base
  EXTS = %w(jpg jpeg gif png).freeze

  include CarrierWave::RMagick

  before :cache, :save_original_filename

  class << self
    def file_storage?
      storage == CarrierWave::Storage::File
    end

    def webdav_storage?
      storage == CarrierWave::Storage::WebDAV
    end
  end

  def extension_white_list
    # Must explicitly resolve constant (to override in subclasses)
    self.class::EXTS
  end

  def store_dir
    "uploads/#{class_name.pluralize}/#{mounted_as}/#{model_id}"
  end

  def cache_dir
    "uploads/tmp/#{class_name.pluralize}"
  end

  def default_url
    "/missing/#{missing_name}"
  end

  def file_path
    if self.class.webdav_storage?
      [webdav_server, path].join('/')
    else
      path
    end
  end

  def filename
    # TODO: fetch correct extension for webdav storage
    "#{secure_token(10)}.jpeg" if original_filename.present?
  end

  private

  def save_original_filename(file)
    return unless file.respond_to?(:original_filename)
    model.original_filename = file.original_filename
  end

  def missing_name(ext = 'jpg')
    name_with_ext = [class_name, ext].join('.')
    [version_name, name_with_ext].compact.join('_')
  end

  def class_name
    model.class.model_name.element
  end

  def model_id
    format('%09d', model.id).scan(/\d{3}/).join('/')
  end

  def secure_token(length = 16)
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) ||
      model.instance_variable_set(var, SecureRandom.hex(length / 2))
  end
end
