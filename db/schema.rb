# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_08_26_110049) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "advertisements", force: :cascade do |t|
    t.string "timestamp"
    t.bigint "company_id", null: false
    t.bigint "datasource_id", null: false
    t.boolean "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_advertisements_on_company_id"
    t.index ["datasource_id"], name: "index_advertisements_on_datasource_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "data_ownerships", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "datasource_id", null: false
    t.boolean "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "type_of_ownership"
    t.index ["company_id"], name: "index_data_ownerships_on_company_id"
    t.index ["datasource_id"], name: "index_data_ownerships_on_datasource_id"
  end

  create_table "datasources", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "downloaded"
    t.float "size"
    t.float "score"
    t.index ["user_id"], name: "index_datasources_on_user_id"
  end

  create_table "interest_recommendations", force: :cascade do |t|
    t.string "category_type"
    t.string "timestamp"
    t.bigint "datasource_id", null: false
    t.boolean "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["datasource_id"], name: "index_interest_recommendations_on_datasource_id"
  end

  create_table "locations", force: :cascade do |t|
    t.float "latitude"
    t.float "longitude"
    t.string "timestamp"
    t.bigint "datasource_id", null: false
    t.boolean "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["datasource_id"], name: "index_locations_on_datasource_id"
  end

  create_table "search_histories", force: :cascade do |t|
    t.text "top_search_words", default: [], array: true
    t.text "top_visited_links", default: [], array: true
    t.date "timestamp"
    t.boolean "deleted", default: false
    t.bigint "datasource_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["datasource_id"], name: "index_search_histories_on_datasource_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "provider"
    t.string "uid"
    t.string "picture_url"
    t.string "token"
    t.datetime "token_expiry"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "youtube_channels", force: :cascade do |t|
    t.string "channel_title"
    t.string "url"
    t.boolean "status"
    t.bigint "datasource_id", null: false
    t.string "timestamp"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["datasource_id"], name: "index_youtube_channels_on_datasource_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "advertisements", "companies"
  add_foreign_key "advertisements", "datasources"
  add_foreign_key "data_ownerships", "companies"
  add_foreign_key "data_ownerships", "datasources"
  add_foreign_key "datasources", "users"
  add_foreign_key "interest_recommendations", "datasources"
  add_foreign_key "locations", "datasources"
  add_foreign_key "search_histories", "datasources"
  add_foreign_key "youtube_channels", "datasources"
end
