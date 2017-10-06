class TagPages < ActiveRecord::Migration[5.1]
  def change
    create_table :tag_pages, comment: 'Compose tags and multi_tags lists from QA-Service' do |t|
      t.integer  :tagable_id
      t.string   :tagable_type
      t.integer  :position_index
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
