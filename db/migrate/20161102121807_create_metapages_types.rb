class CreateMetapagesTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :metapages_types, comment: 'URL and names SEO-pages' do |t|
      t.timestamps

      t.string    :name
      t.string    :url
    end
    add_column :metapages, :metapages_type_id, :integer
  end
end
