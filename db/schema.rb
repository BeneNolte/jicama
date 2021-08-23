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

ActiveRecord::Schema.define(version: 2021_08_23_151027) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "advertisements", force: :cascade do |t|
    t.date "timestamp"
    t.bigint "company_id", null: false
    t.bigint "datasource_id", null: false
    t.string "status"
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
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_data_ownerships_on_company_id"
    t.index ["datasource_id"], name: "index_data_ownerships_on_datasource_id"
  end

  create_table "datasources", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_datasources_on_user_id"
  end

  create_table "interest_recommendations", force: :cascade do |t|
    t.string "category_type"
    t.date "timestamp"
    t.bigint "datasource_id", null: false
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["datasource_id"], name: "index_interest_recommendations_on_datasource_id"
  end

  create_table "locations", force: :cascade do |t|
    t.float "latitude"
    t.float "longitude"
    t.date "timestamp"
    t.bigint "datasource_id", null: false
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["datasource_id"], name: "index_locations_on_datasource_id"
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "youtube_channels", force: :cascade do |t|
    t.string "channel_title"
    t.string "url"
    t.string "status"
    t.bigint "datasource_id", null: false
    t.date "timestamp"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["datasource_id"], name: "index_youtube_channels_on_datasource_id"
  end

  add_foreign_key "advertisements", "companies"
  add_foreign_key "advertisements", "datasources"
  add_foreign_key "data_ownerships", "companies"
  add_foreign_key "data_ownerships", "datasources"
  add_foreign_key "datasources", "users"
  add_foreign_key "interest_recommendations", "datasources"
  add_foreign_key "locations", "datasources"
  add_foreign_key "youtube_channels", "datasources"
end
