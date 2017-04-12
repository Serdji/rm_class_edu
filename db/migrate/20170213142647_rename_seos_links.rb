class RenameSeosLinks < ActiveRecord::Migration[5.0]
  def change
    rename_table :seos_links, :seo_links
  end
end
