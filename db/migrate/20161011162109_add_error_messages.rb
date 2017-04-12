class AddErrorMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :error_messages do |t|
      t.timestamps

      t.string :message
      t.string :email
      t.string :name
    end
  end
end
