class AddMenu < ActiveRecord::Migration[5.1]
  def change
    create_table :menu do |t|
      t.json :left_side, default: []
      t.json :right_side, default: []
    end

    TagMenu.create

    create_table :menu_tags do |t|
      t.integer :tag_id
      t.integer :position
    end

    create_table :menu_tag_groups do |t|
      t.integer :tag_id
      t.integer :tag_ids, array: true, default: []
      t.integer :position
    end
  end
end
