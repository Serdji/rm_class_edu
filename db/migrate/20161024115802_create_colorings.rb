class CreateColorings < ActiveRecord::Migration[5.0]
  def change
    create_table :colorings do |t|
      t.integer :color_id

      t.string :colorable_type
      t.integer :colorable_id

      t.datetime
    end

    add_index :colorings, [:colorable_type, :colorable_id]
  end
end
