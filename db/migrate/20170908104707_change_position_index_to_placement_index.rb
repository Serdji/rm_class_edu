class ChangePositionIndexToPlacementIndex < ActiveRecord::Migration[5.1]
  def change
    rename_column :tag_pages, :position_index, :placement_index
  end
end
