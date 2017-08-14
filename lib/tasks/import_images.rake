require 'csv'
require 'pathname'
require 'fileutils'

class ImagesImporter
  class ImageStruct < Struct.new(:row)
    KEYS = %i(imageable_id imageable_type type remote_image_url).freeze

    def imageable_id
      row.first
    end

    def imageable_type
      "Qa::#{row.second}"
    end

    def remote_image_url
      row.last
    end

    def type
      "Images::#{row.second}"
    end

    def to_h
      KEYS.map { |key| [key, send(key)] }.to_h
    end

    def damaged?
      to_h.value?(nil)
    end
  end

  class << self
    def run(path)
      new(path).run
    end
  end

  def initialize(path)
    @path = path
  end

  def run
    CSV.foreach(@path) do |row|
      struct = ImageStruct.new(row)
      puts "Import image: #{struct.remote_image_url}"

      unless struct.damaged?
        attributes = struct.to_h
        temp_image = download_image(attributes.delete(:remote_image_url))
        begin
          Image.create!(attributes.merge(image: temp_image))
        rescue
          FileUtils.rm temp_image.path
          raise
        end
      end
    end
  rescue Errno::ENOENT
    abort "File #{@path} not found"
  end

  private

  def download_image(url)
    `curl -s -k -O #{url}`
    File.open(Pathname.new(url).basename, 'r')
  end
end

task import_images: :environment do
  abort 'Environment FILEPATH is not set' unless ENV['FILEPATH']

  class TempImage < Image
    self.inheritance_column = nil
    self.table_name = 'images'
  end

  TempImage.destroy_all
  ImagesImporter.run(ENV['FILEPATH'])
end
