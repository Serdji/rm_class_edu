class SeosLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :seos_links do |t|
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.string :title
      t.string :url
    end
  end
end
