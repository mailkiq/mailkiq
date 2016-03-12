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

ActiveRecord::Schema.define(version: 20160226005238) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"
  enable_extension "uuid-ossp"

  create_table "accounts", force: :cascade do |t|
    t.string   "name",                                                                      null: false
    t.citext   "email",                                                                     null: false
    t.string   "encrypted_password",             limit: 128
    t.string   "confirmation_token",             limit: 128
    t.string   "remember_token",                 limit: 128
    t.string   "language"
    t.string   "time_zone",                                  default: "UTC"
    t.uuid     "api_key",                                    default: "uuid_generate_v4()"
    t.string   "aws_access_key_id"
    t.string   "aws_secret_access_key"
    t.string   "aws_region"
    t.string   "paypal_customer_token"
    t.string   "paypal_recurring_profile_token"
    t.integer  "plan_id"
    t.datetime "created_at",                                                                null: false
    t.datetime "updated_at",                                                                null: false
  end

  add_index "accounts", ["api_key"], name: "index_accounts_on_api_key", unique: true, using: :btree
  add_index "accounts", ["email"], name: "index_accounts_on_email", unique: true, using: :btree
  add_index "accounts", ["remember_token"], name: "index_accounts_on_remember_token", using: :btree

  create_table "campaigns", force: :cascade do |t|
    t.string   "name",                            null: false
    t.string   "subject",                         null: false
    t.string   "from_name",                       null: false
    t.string   "from_email",                      null: false
    t.string   "reply_to"
    t.text     "plain_text"
    t.text     "html_text",                       null: false
    t.integer  "recipients_count",    default: 0, null: false
    t.integer  "unique_opens_count",  default: 0, null: false
    t.integer  "unique_clicks_count", default: 0, null: false
    t.integer  "account_id",                      null: false
    t.datetime "sent_at"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "campaigns", ["account_id"], name: "index_campaigns_on_account_id", using: :btree

  create_table "domains", force: :cascade do |t|
    t.citext   "name",               null: false
    t.string   "verification_token", null: false
    t.integer  "status",             null: false
    t.text     "dkim_tokens",        null: false, array: true
    t.integer  "account_id",         null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "domains", ["account_id"], name: "index_domains_on_account_id", using: :btree
  add_index "domains", ["name"], name: "index_domains_on_name", unique: true, using: :btree

  create_table "messages", force: :cascade do |t|
    t.string   "uuid",          limit: 60, null: false
    t.string   "token",         limit: 32, null: false
    t.string   "referer"
    t.string   "user_agent"
    t.inet     "last_open_ip"
    t.integer  "subscriber_id",            null: false
    t.integer  "campaign_id",              null: false
    t.datetime "sent_at",                  null: false
    t.datetime "opened_at"
    t.datetime "clicked_at"
  end

  add_index "messages", ["campaign_id"], name: "index_messages_on_campaign_id", using: :btree
  add_index "messages", ["subscriber_id"], name: "index_messages_on_subscriber_id", using: :btree
  add_index "messages", ["token"], name: "index_messages_on_token", using: :btree
  add_index "messages", ["uuid"], name: "index_messages_on_uuid", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer "type",       null: false
    t.jsonb   "metadata",   null: false
    t.integer "message_id", null: false
  end

  add_index "notifications", ["message_id"], name: "index_notifications_on_message_id", using: :btree

  create_table "plans", force: :cascade do |t|
    t.string   "name",       null: false
    t.decimal  "price",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscribers", force: :cascade do |t|
    t.string   "name",                       null: false
    t.string   "email",                      null: false
    t.integer  "state",                      null: false
    t.jsonb    "custom_fields", default: {}, null: false
    t.integer  "account_id",                 null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "subscribers", ["account_id", "email"], name: "index_subscribers_on_account_id_and_email", unique: true, using: :btree
  add_index "subscribers", ["account_id"], name: "index_subscribers_on_account_id", using: :btree
  add_index "subscribers", ["custom_fields"], name: "index_subscribers_on_custom_fields", using: :gin

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        null: false
    t.integer  "subscriber_id", null: false
    t.datetime "created_at",    null: false
  end

  add_index "taggings", ["subscriber_id"], name: "index_taggings_on_subscriber_id", using: :btree
  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "slug",       null: false
    t.integer  "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tags", ["account_id"], name: "index_tags_on_account_id", using: :btree
  add_index "tags", ["slug", "account_id"], name: "index_tags_on_slug_and_account_id", unique: true, using: :btree

  add_foreign_key "campaigns", "accounts"
  add_foreign_key "domains", "accounts"
  add_foreign_key "messages", "campaigns"
  add_foreign_key "messages", "subscribers"
  add_foreign_key "notifications", "messages"
  add_foreign_key "subscribers", "accounts"
  add_foreign_key "taggings", "subscribers"
  add_foreign_key "taggings", "tags"
  add_foreign_key "tags", "accounts"
end
