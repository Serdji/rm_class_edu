class Menu::Tag < ActiveRecord::Base
  self.table_name = :menu_tags

  scope :ordered, -> { order(:position) }
end
