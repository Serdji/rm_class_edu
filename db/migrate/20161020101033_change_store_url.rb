class ChangeStoreUrl < ActiveRecord::Migration[5.0]
  def change
    add_column :store_urls, :shop_id, :integer
    add_index  :store_urls, [:shop_id], name: :index_store_urls_on_shop_id, using: :btree
    add_column :store_urls, :price, :decimal, precision: 10, scale: 2

    create_table :shops do |t|
      t.timestamps

      t.string :name
    end
  end
end
