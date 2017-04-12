class AddOriginalFilenameToImages < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :original_filename, :string
  end
end
