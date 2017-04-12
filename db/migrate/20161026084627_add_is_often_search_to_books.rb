class AddIsOftenSearchToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :is_often_search, :boolean, default: false
  end
end
