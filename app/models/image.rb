class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true, touch: true

  # Default mounter if not defined in subclasses
  mount_uploader :image, ImageUploader

  # Default validation for all subclasses
  # validates :image, presence: true

  # If create or update then try to async reprocess image
  after_commit :reprocess, if: -> { persisted? && temp_image_url.present? }

  # In worker we must call origin method
  alias orig_remove_image! remove_image!

  def remove_image!
    image_urls.each do |image_url|
      ImageRemoveJob.perform(self.class.name, 'image', image_url)
    end
  end

  private

  def image_urls
    versions = [image]
    versions += image.versions.values

    versions.map(&:file_path)
  end

  def reprocess
    ImageProcessJob.perform(id)
  end
end
