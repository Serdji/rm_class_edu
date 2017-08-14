class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true

  # Default mounter if not defined in subclasses
  mount_uploader :image, ImageUploader

  # Default validation for all subclasses
  # validates :image, presence: true

  def imageable
    if imageable_type.start_with?('Qa')
      imageable_type.constantize.find(imageable_id)
    else
      super
    end
  end
end
