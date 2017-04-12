class ColapseMigrationsAndSortColumns < ActiveRecord::Migration[5.0]
  def change

    create_table  :author_books, force: :cascade do |t|
      t.datetime  :created_at, null: false
      t.datetime  :updated_at, null: false
      t.integer   :author_id
      t.integer   :book_id
      t.index [:author_id], name:  :index_author_books_on_author_id, using: :btree
      t.index [:book_id], name:  :index_author_books_on_book_id, using: :btree
    end

    create_table  :authors, force: :cascade do |t|
      t.datetime  :created_at,                  null: false
      t.datetime  :updated_at,                  null: false
      t.boolean   :is_published, default: true, null: false
      t.string    :first_name
      t.string    :last_name
      t.string    :patronymic
      t.string    :slug
      t.text      :description
      t.index [:slug], name:  :index_authors_on_slug, using: :btree
    end

    create_table  :books, force: :cascade do |t|
      t.datetime  :created_at,                    null: false
      t.datetime  :updated_at,                    null: false
      t.datetime  :published_at
      t.boolean   :is_popular,    default: false, null: false
      t.boolean   :on_main_page,  default: false, null: false
      t.integer   :publishing_id
      t.integer   :subject_id
      t.integer   :year
      t.integer   :weight,        default: 100,   null: false
      t.integer   :state,         default: 0,     null: false
      t.string    :name
      t.string    :isbn
      t.string    :udk
      t.string    :bbk
      t.string    :type
      t.string    :slug
      t.string    :books_title
      t.text      :description
      t.index [:isbn], name:  :index_books_on_isbn, using: :btree
      t.index [:publishing_id], name:  :index_books_on_publishing_id, using: :btree
      t.index [:slug], name:  :index_books_on_slug, using: :btree
      t.index [:state], name:  :index_books_on_state, using: :btree
      t.index [:subject_id], name:  :index_books_on_subject_id, using: :btree
    end

    create_table  :catalogs, force: :cascade do |t|
      t.string    :name
      t.string    :slug
      t.integer   :book_id,                       null: false
      t.integer   :parent_id
      t.integer   :lft,                           null: false
      t.integer   :rgt,                           null: false
      t.boolean   :is_published,   default: true, null: false
      t.integer   :depth,          default: 0,    null: false
      t.integer   :children_count, default: 0,    null: false
      t.datetime  :created_at,                    null: false
      t.datetime  :updated_at,                    null: false
      t.index [:book_id], name:  :index_catalogs_on_book_id, using: :btree
      t.index [:lft], name:  :index_catalogs_on_lft, using: :btree
      t.index [:parent_id], name:  :index_catalogs_on_parent_id, using: :btree
      t.index [:rgt], name:  :index_catalogs_on_rgt, using: :btree
    end

    create_table  :employees, force: :cascade do |t|
      t.datetime  :created_at,                       null: false
      t.datetime  :updated_at,                       null: false
      t.datetime  :remember_created_at
      t.datetime  :current_sign_in_at
      t.datetime  :last_sign_in_at
      t.integer   :sign_in_count,       default: 0,  null: false
      t.inet      :current_sign_in_ip
      t.inet      :last_sign_in_ip
      t.string    :email,               default: "", null: false
      t.string    :first_name
      t.string    :last_name
      t.string    :encrypted_password,  default: "", null: false
      t.index [:email], name:  :index_employees_on_email, unique: true, using: :btree
    end

    create_table  :grade_books, force: :cascade do |t|
      t.datetime  :created_at, null: false
      t.datetime  :updated_at, null: false
      t.integer   :grade_id
      t.integer   :book_id
      t.index [:book_id], name:  :index_grade_books_on_book_id, using: :btree
      t.index [:grade_id], name:  :index_grade_books_on_grade_id, using: :btree
    end

    create_table  :grades, force: :cascade do |t|
      t.datetime  :created_at,                  null: false
      t.datetime  :updated_at,                  null: false
      t.boolean   :is_published, default: true, null: false
      t.integer   :grade,                       null: false
      t.string    :name
      t.string    :slug
      t.index [:slug], name:  :index_grades_on_slug, using: :btree
    end

    create_table  :images, force: :cascade do |t|
      t.datetime  :created_at,     null: false
      t.datetime  :updated_at,     null: false
      t.integer   :imageable_id
      t.string    :imageable_type
      t.string    :type
      t.string    :image
      t.string    :temp_image_url
      t.string    :alt_text
    end

    create_table  :memberships, force: :cascade do |t|
      t.datetime  :created_at,   null: false
      t.datetime  :updated_at,   null: false
      t.integer   :rolable_id
      t.integer   :role_id
      t.string    :rolable_type
      t.index [:rolable_id], name:  :index_memberships_on_rolable_id, using: :btree
      t.index [:role_id], name:  :index_memberships_on_role_id, using: :btree
    end

    create_table  :pages, force: :cascade do |t|
      t.datetime  :created_at,                   null: false
      t.datetime  :updated_at,                   null: false
      t.boolean   :is_published, default: false, null: false
      t.string    :name
      t.string    :slug
      t.text      :content
    end

    create_table  :paragraphs, force: :cascade do |t|
      t.datetime  :created_at,                      null: false
      t.datetime  :updated_at,                      null: false
      t.datetime  :published_at
      t.integer   :catalog_id,                      null: false
      t.integer   :placement_index, default: 0,     null: false
      t.integer   :state,           default: 0,     null: false
      t.boolean   :is_empty,        default: false, null: false
      t.boolean   :on_main_page,    default: false, null: false
      t.string    :slug
      t.string    :name
      t.text      :condition
      t.text      :solution
      t.text      :answer
      t.text      :author_info
      t.index [:catalog_id], name:  :index_paragraphs_on_catalog_id, using: :btree
    end

    create_table  :publishings, force: :cascade do |t|
      t.datetime  :created_at,                  null: false
      t.datetime  :updated_at,                  null: false
      t.boolean   :is_published, default: true, null: false
      t.string    :name
      t.string    :slug
      t.index [:slug], name:  :index_publishings_on_slug, using: :btree
    end

    create_table  :roles, force: :cascade do |t|
      t.datetime  :created_at,  null: false
      t.datetime  :updated_at,  null: false
      t.string    :name
      t.json      :credentials
    end

    create_table  :seos, force: :cascade do |t|
      t.datetime  :created_at,   null: false
      t.datetime  :updated_at,   null: false
      t.integer   :seoable_id
      t.string    :seoable_type
      t.text      :keywords
      t.text      :title
      t.text      :description
      t.index [:seoable_id, :seoable_type], name:  :index_seos_on_seoable_id_and_seoable_type, using: :btree
    end

    create_table  :settings, force: :cascade do |t|
      t.datetime  :created_at
      t.datetime  :updated_at
      t.integer   :thing_id
      t.string    :thing_type, limit: 30
      t.string    :var,                   null: false
      t.text      :value
      t.index [:thing_type, :thing_id, :var], name:  :index_settings_on_thing_type_and_thing_id_and_var, unique: true, using: :btree
    end

    create_table  :store_urls, force: :cascade do |t|
      t.datetime  :created_at, null: false
      t.datetime  :updated_at, null: false
      t.integer   :book_id
      t.string    :url
    end

    create_table  :subjects, force: :cascade do |t|
      t.datetime  :created_at,                  null: false
      t.datetime  :updated_at,                  null: false
      t.integer   :weight,       default: 100,  null: false, comment:  'Weight for sorting of orders'
      t.boolean   :is_published, default: true, null: false
      t.string    :name
      t.string    :slug
      t.index [:slug], name:  :index_subjects_on_slug, using: :btree
    end

    create_table  :textbook_blockbooks, force: :cascade do |t|
      t.datetime  :created_at,   null: false
      t.datetime  :updated_at,   null: false
      t.integer   :blockbook_id
      t.integer   :textbook_id
      t.index [:blockbook_id], name:  :index_textbook_blockbooks_on_blockbook_id, using: :btree
      t.index [:textbook_id], name:  :index_textbook_blockbooks_on_textbook_id, using: :btree
    end

    create_table  :users, force: :cascade do |t|
      t.datetime  :created_at, null: false
      t.datetime  :updated_at, null: false
    end

    create_table  :versions, force: :cascade do |t|
      t.datetime  :created_at
      t.integer   :item_id,        null: false
      t.integer   :whodunnit
      t.string    :item_type,      null: false
      t.string    :event,          null: false
      t.text      :object
      t.text      :object_changes
      t.index [:item_type, :item_id], name:  :index_versions_on_item_type_and_item_id, using: :btree
    end

  end
end
