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

  create_table "messages", force: :cascade do |t|
    t.string   "uid"
    t.string   "token"
    t.integer  "subscriber_id", null: false
    t.integer  "campaign_id",   null: false
    t.datetime "sent_at"
    t.datetime "opened_at"
    t.datetime "clicked_at"
  end

  add_index "messages", ["campaign_id"], name: "index_messages_on_campaign_id", using: :btree
  add_index "messages", ["subscriber_id"], name: "index_messages_on_subscriber_id", using: :btree
  add_index "messages", ["token"], name: "index_messages_on_token", using: :btree
  add_index "messages", ["uid"], name: "index_messages_on_uid", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.string "message_uid", null: false
    t.jsonb  "data",        null: false
  end

  add_index "notifications", ["message_uid"], name: "index_notifications_on_message_uid", using: :btree

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

  add_foreign_key "campaigns", "accounts"
  add_foreign_key "messages", "campaigns"
  add_foreign_key "messages", "subscribers"
  add_foreign_key "subscribers", "accounts"
end
