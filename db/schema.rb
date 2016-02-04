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

ActiveRecord::Schema.define(version: 20160203115340) do

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

  create_table "ahoy_messages", force: :cascade do |t|
    t.string   "token"
    t.string   "message_id"
    t.text     "to",          null: false
    t.integer  "user_id",     null: false
    t.string   "user_type",   null: false
    t.integer  "campaign_id", null: false
    t.datetime "sent_at"
    t.datetime "opened_at"
    t.datetime "clicked_at"
  end

  add_index "ahoy_messages", ["campaign_id"], name: "index_ahoy_messages_on_campaign_id", using: :btree
  add_index "ahoy_messages", ["message_id"], name: "index_ahoy_messages_on_message_id", using: :btree
  add_index "ahoy_messages", ["token"], name: "index_ahoy_messages_on_token", using: :btree
  add_index "ahoy_messages", ["user_type", "user_id"], name: "index_ahoy_messages_on_user_type_and_user_id", using: :btree

  create_table "campaigns", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "subject",    null: false
    t.string   "from_name",  null: false
    t.string   "from_email", null: false
    t.string   "reply_to"
    t.text     "plain_text"
    t.text     "html_text",  null: false
    t.integer  "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "campaigns", ["account_id"], name: "index_campaigns_on_account_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.jsonb    "message",    null: false
    t.integer  "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "notifications", ["account_id"], name: "index_notifications_on_account_id", using: :btree

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

  add_foreign_key "ahoy_messages", "campaigns"
  add_foreign_key "campaigns", "accounts"
  add_foreign_key "notifications", "accounts"
  add_foreign_key "subscribers", "accounts"
end
