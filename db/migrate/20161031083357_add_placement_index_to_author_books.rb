class AddPlacementIndexToAuthorBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :author_books, :placement_index, :integer, default: 0
  end
end
