class CreateMetapages < ActiveRecord::Migration[5.0]
  def change
    create_table :metapages do |t|
      t.timestamps

      t.integer   :grade_id
      t.integer   :subject_id
      t.string    :label, comment: 'Label note for admin employeers'
      t.string    :title, comment: 'H1-title of page'
      t.text      :description
    end
  end
end
