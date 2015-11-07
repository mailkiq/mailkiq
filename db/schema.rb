# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151103162605) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"

  create_table "accounts", force: :cascade do |t|
    t.string "name",                              null: false
    t.citext "email",                             null: false
    t.string "encrypted_password",    limit: 128
    t.string "confirmation_token",    limit: 128
    t.string "remember_token",        limit: 128
    t.string "aws_access_key_id"
    t.string "aws_secret_access_key"
    t.string "aws_region"
    t.string "language"
    t.string "time_zone"
  end

  add_index "accounts", ["email"], name: "index_accounts_on_email", unique: true, using: :btree
  add_index "accounts", ["remember_token"], name: "index_accounts_on_remember_token", using: :btree

  create_table "campaigns", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "subject",    null: false
    t.string   "from_name",  null: false
    t.string   "from_email", null: false
    t.string   "reply_to"
    t.text     "plain_text"
    t.text     "html_text",  null: false
    t.integer  "list_id",    null: false
    t.integer  "account_id", null: false
    t.datetime "send_at",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "campaigns", ["account_id"], name: "index_campaigns_on_account_id", using: :btree
  add_index "campaigns", ["list_id"], name: "index_campaigns_on_list_id", using: :btree

  create_table "custom_fields", force: :cascade do |t|
    t.string   "key",                    null: false
    t.integer  "data_type",  default: 0, null: false
    t.string   "field_name",             null: false
    t.integer  "list_id",                null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "custom_fields", ["field_name", "list_id"], name: "index_custom_fields_on_field_name_and_list_id", unique: true, using: :btree
  add_index "custom_fields", ["list_id"], name: "index_custom_fields_on_list_id", using: :btree

  create_table "lists", force: :cascade do |t|
    t.string   "name",                                 null: false
    t.boolean  "double_optin",         default: false, null: false
    t.string   "confirm_url"
    t.string   "subscribed_url"
    t.string   "unsubscribed_url"
    t.boolean  "thankyou",             default: false, null: false
    t.string   "thankyou_subject"
    t.text     "thankyou_message"
    t.boolean  "goodbye",              default: false, null: false
    t.string   "goodbye_subject"
    t.text     "goodbye_message"
    t.string   "confirmation_subject"
    t.text     "confirmation_message"
    t.boolean  "unsubscribe_all_list", default: true,  null: false
    t.integer  "account_id",                           null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "lists", ["account_id"], name: "index_lists_on_account_id", using: :btree

  create_table "subscribers", force: :cascade do |t|
    t.string   "name",                       null: false
    t.string   "email",                      null: false
    t.jsonb    "custom_fields", default: {}, null: false
    t.integer  "account_id",                 null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "subscribers", ["account_id", "email"], name: "index_subscribers_on_account_id_and_email", unique: true, using: :btree
  add_index "subscribers", ["account_id"], name: "index_subscribers_on_account_id", using: :btree
  add_index "subscribers", ["custom_fields"], name: "index_subscribers_on_custom_fields", using: :gin

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "status",        null: false
    t.integer  "list_id",       null: false
    t.integer  "subscriber_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "subscriptions", ["list_id"], name: "index_subscriptions_on_list_id", using: :btree
  add_index "subscriptions", ["subscriber_id"], name: "index_subscriptions_on_subscriber_id", using: :btree

  create_table "templates", force: :cascade do |t|
    t.string   "name",       null: false
    t.text     "html_text",  null: false
    t.integer  "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "templates", ["account_id"], name: "index_templates_on_account_id", using: :btree

  add_foreign_key "campaigns", "accounts"
  add_foreign_key "custom_fields", "lists"
  add_foreign_key "lists", "accounts"
  add_foreign_key "subscribers", "accounts"
  add_foreign_key "subscriptions", "subscribers"
  add_foreign_key "templates", "accounts"
end
