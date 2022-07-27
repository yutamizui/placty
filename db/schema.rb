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

ActiveRecord::Schema.define(version: 2022_07_26_014439) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bank_accounts", force: :cascade do |t|
    t.string "email"
    t.string "account_holder"
    t.string "institution_number"
    t.string "transit_number"
    t.string "ach_routing_number"
    t.string "bsb_code"
    t.string "uk_sort_code"
    t.string "bank_name"
    t.string "branch_name"
    t.integer "account_type"
    t.string "account_number"
    t.string "iban"
    t.integer "currency"
    t.string "country_name"
    t.string "city_name"
    t.string "recipient_address"
    t.string "post_code"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_bank_accounts_on_user_id"
  end

  create_table "challenges", force: :cascade do |t|
    t.string "title"
    t.string "target_user"
    t.integer "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0
    t.datetime "deadline"
    t.integer "progress", default: 0
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "date"
    t.string "location"
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "length", default: 10
    t.integer "point", default: 0
    t.integer "limit_number", default: 1, null: false
    t.bigint "language_id"
    t.boolean "status", default: true
    t.index ["language_id"], name: "index_events_on_language_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "status", default: false
    t.index ["user_id"], name: "index_invoices_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.text "note"
    t.integer "percentage"
    t.bigint "challenge_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["challenge_id"], name: "index_items_on_challenge_id"
  end

  create_table "languages", force: :cascade do |t|
    t.string "ja_name"
    t.string "en_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "notes", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title", null: false
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "notice_boards", force: :cascade do |t|
    t.bigint "language_id"
    t.bigint "user_id"
    t.text "note", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["language_id"], name: "index_notice_boards_on_language_id"
    t.index ["user_id"], name: "index_notice_boards_on_user_id"
  end

  create_table "points", force: :cascade do |t|
    t.datetime "expired_at"
    t.integer "user_id"
    t.boolean "status", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reports", force: :cascade do |t|
    t.bigint "challenge_id"
    t.bigint "user_id"
    t.string "completed_item"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "total_percentage", default: 0
    t.datetime "target_date"
    t.integer "completed_percentage", default: 0
    t.index ["challenge_id"], name: "index_reports_on_challenge_id"
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.integer "user_id"
    t.integer "event_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ja_name"
    t.string "en_name"
    t.string "customer_id"
    t.datetime "start_day"
    t.string "image"
    t.integer "penalty", default: 0, null: false
    t.integer "redeem_point", default: 0
    t.string "time_zone_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bank_accounts", "users"
  add_foreign_key "events", "languages"
  add_foreign_key "invoices", "users"
  add_foreign_key "items", "challenges"
  add_foreign_key "notice_boards", "languages"
  add_foreign_key "notice_boards", "users"
  add_foreign_key "reports", "challenges"
  add_foreign_key "reports", "users"
end
