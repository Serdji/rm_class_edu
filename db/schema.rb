# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170809111320) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "author_books", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "author_id"
    t.integer "book_id"
    t.integer "placement_index", default: 0
    t.index ["author_id"], name: "index_author_books_on_author_id"
    t.index ["book_id"], name: "index_author_books_on_book_id"
  end

  create_table "authors", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_published", default: true, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "patronymic"
    t.string "slug"
    t.text "description"
    t.index ["slug"], name: "index_authors_on_slug"
  end

  create_table "books", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "published_at"
    t.boolean "is_popular", default: false, null: false
    t.boolean "on_main_page", default: false, null: false
    t.integer "publishing_id"
    t.integer "subject_id"
    t.integer "year"
    t.integer "weight", default: 100, null: false
    t.integer "state", default: 0, null: false
    t.string "name"
    t.string "isbn"
    t.string "udk"
    t.string "bbk"
    t.string "type"
    t.string "slug"
    t.string "books_title"
    t.text "description"
    t.string "block_name"
    t.boolean "is_often_search", default: false
    t.index ["isbn"], name: "index_books_on_isbn"
    t.index ["publishing_id"], name: "index_books_on_publishing_id"
    t.index ["slug"], name: "index_books_on_slug"
    t.index ["state"], name: "index_books_on_state"
    t.index ["subject_id"], name: "index_books_on_subject_id"
  end

  create_table "catalogs", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.integer "book_id", null: false
    t.integer "parent_id"
    t.integer "lft", null: false
    t.integer "rgt", null: false
    t.boolean "is_published", default: true, null: false
    t.integer "depth", default: 0, null: false
    t.integer "children_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_catalogs_on_book_id"
    t.index ["lft"], name: "index_catalogs_on_lft"
    t.index ["parent_id"], name: "index_catalogs_on_parent_id"
    t.index ["rgt"], name: "index_catalogs_on_rgt"
  end

  create_table "colorings", id: :serial, force: :cascade do |t|
    t.integer "color_id"
    t.string "colorable_type"
    t.integer "colorable_id"
    t.index ["colorable_type", "colorable_id"], name: "index_colorings_on_colorable_type_and_colorable_id"
  end

  create_table "colors", id: :serial, force: :cascade do |t|
    t.string "value"
  end

  create_table "employees", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "remember_created_at"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.integer "sign_in_count", default: 0, null: false
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "encrypted_password", default: "", null: false
    t.integer "role_id"
    t.index ["email"], name: "index_employees_on_email", unique: true
    t.index ["role_id"], name: "index_employees_on_role_id"
  end

  create_table "error_messages", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "message"
    t.string "email"
    t.string "name"
  end

  create_table "grade_books", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "grade_id"
    t.integer "book_id"
    t.index ["book_id"], name: "index_grade_books_on_book_id"
    t.index ["grade_id"], name: "index_grade_books_on_grade_id"
  end

  create_table "grades", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_published", default: true, null: false
    t.integer "grade", null: false
    t.string "name"
    t.string "slug"
    t.index ["slug"], name: "index_grades_on_slug"
  end

  create_table "images", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "imageable_id"
    t.string "imageable_type"
    t.string "type"
    t.string "image"
    t.string "original_filename"
    t.index ["imageable_id", "imageable_type", "type"], name: "index_images_on_imageable_id_and_imageable_type_and_type"
    t.index ["type"], name: "index_images_on_type"
  end

  create_table "memberships", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rolable_id"
    t.integer "role_id"
    t.string "rolable_type"
    t.index ["rolable_id"], name: "index_memberships_on_rolable_id"
    t.index ["role_id"], name: "index_memberships_on_role_id"
  end

  create_table "menu", force: :cascade do |t|
    t.json "left_side", default: []
    t.json "right_side", default: []
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menu_tag_groups", force: :cascade do |t|
    t.integer "tag_id"
    t.integer "tag_ids", default: [], array: true
    t.integer "position"
  end

  create_table "menu_tags", force: :cascade do |t|
    t.integer "tag_id"
    t.integer "position"
  end

  create_table "metapages", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "grade_id"
    t.integer "subject_id"
    t.string "label", comment: "Label note for admin employeers"
    t.string "title", comment: "H1-title of page"
    t.text "description"
    t.integer "metapages_type_id"
  end

  create_table "metapages_types", id: :serial, force: :cascade, comment: "URL and names SEO-pages" do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "url"
  end

  create_table "pages", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_published", default: false, null: false
    t.string "name"
    t.string "slug"
    t.text "content"
  end

  create_table "paragraphs", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "published_at"
    t.integer "catalog_id", null: false
    t.integer "placement_index", default: 0, null: false
    t.integer "state", default: 0, null: false
    t.boolean "is_empty", default: false, null: false
    t.boolean "on_main_page", default: false, null: false
    t.string "slug"
    t.string "name"
    t.text "condition"
    t.text "solution"
    t.text "answer"
    t.text "author_info"
    t.index ["catalog_id"], name: "index_paragraphs_on_catalog_id"
  end

  create_table "publishings", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_published", default: true, null: false
    t.string "name"
    t.string "slug"
    t.index ["slug"], name: "index_publishings_on_slug"
  end

  create_table "redirects", force: :cascade do |t|
    t.string "entity_type"
    t.integer "entity_id"
    t.string "redirect_type"
    t.integer "redirect_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_type", "entity_id"], name: "index_redirects_on_entity_type_and_entity_id"
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.json "credentials"
  end

  create_table "seo_links", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "url"
  end

  create_table "seos", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "seoable_id"
    t.string "seoable_type"
    t.text "keywords"
    t.text "title"
    t.text "description"
    t.index ["seoable_id", "seoable_type"], name: "index_seos_on_seoable_id_and_seoable_type"
  end

  create_table "settings", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "thing_id"
    t.string "thing_type", limit: 30
    t.string "var", null: false
    t.text "value"
    t.index ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true
  end

  create_table "shops", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "store_urls", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "book_id"
    t.string "url"
    t.integer "shop_id"
    t.decimal "price", precision: 10, scale: 2
    t.index ["shop_id"], name: "index_store_urls_on_shop_id"
  end

  create_table "subjects", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "weight", default: 100, null: false, comment: "Weight for sorting of orders"
    t.boolean "is_published", default: true, null: false
    t.string "name"
    t.string "slug"
    t.index ["slug"], name: "index_subjects_on_slug"
  end

  create_table "textbook_blockbooks", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "blockbook_id"
    t.integer "textbook_id"
    t.index ["blockbook_id"], name: "index_textbook_blockbooks_on_blockbook_id"
    t.index ["textbook_id"], name: "index_textbook_blockbooks_on_textbook_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "versions", force: :cascade, comment: "Employees' activities" do |t|
    t.integer "employee_id"
    t.integer "item_id"
    t.string "item_type"
    t.string "event"
    t.text "object"
    t.datetime "created_at"
  end

end
