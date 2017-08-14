class AddRedirects < ActiveRecord::Migration[5.1]
  def change
    create_table :redirects do |t|
      t.string :entity_type
      t.integer :entity_id

      t.string :redirect_type
      t.integer :redirect_id

      t.timestamps
    end

    add_index :redirects, [:entity_type, :entity_id]
  end
end
