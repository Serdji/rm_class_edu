class CreateLogs < ActiveRecord::Migration[5.1]
  def change
    drop_table :versions
    create_table :versions, comment: 'Employees\' activities' do |t|
      t.integer  :employee_id
      t.integer  :item_id
      t.string   :item_type
      t.string   :event
      t.text     :object
      t.datetime :created_at
    end
  end
end
