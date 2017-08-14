class AddTimestampsToMenuTag < ActiveRecord::Migration[5.1]
  def up
    add_column :menu, :created_at, :datetime
    add_column :menu, :updated_at, :datetime

    menu = TagMenu.menu

    if menu
      menu.update_attribute(:updated_at, Time.current) unless menu.updated_at
      menu.update_attribute(:created_at, Time.current) unless menu.created_at
    end
  end

  def down
    remove_column :created_at
    remove_column :updated_at
  end
end
