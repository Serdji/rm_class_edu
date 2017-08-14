class ChangeImages < ActiveRecord::Migration[5.1]
  def change
    remove_column :images, :temp_image_url
    remove_column :images, :alt_text

    add_index :images, :type
    add_index :images, [:imageable_id, :imageable_type, :type]
  end
end
