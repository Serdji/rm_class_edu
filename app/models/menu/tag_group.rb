class Menu::TagGroup < ActiveRecord::Base
  self.table_name = :menu_tag_groups

  scope :ordered, -> { order(:position) }
end
