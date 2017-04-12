class AddBlockNameToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :block_name, :string
  end
end
