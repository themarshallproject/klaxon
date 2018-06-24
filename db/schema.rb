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

ActiveRecord::Schema.define(version: 20170526193719) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "app_settings", force: :cascade do |t|
    t.string   "key"
    t.text     "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "app_settings", ["key"], name: "index_app_settings_on_key", using: :btree

  create_table "changes", force: :cascade do |t|
    t.integer  "before_id"
    t.string   "before_type"
    t.integer  "after_id"
    t.string   "after_type"
    t.text     "summary"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "changes", ["after_id"], name: "index_changes_on_after_id", using: :btree
  add_index "changes", ["after_type"], name: "index_changes_on_after_type", using: :btree
  add_index "changes", ["before_id"], name: "index_changes_on_before_id", using: :btree
  add_index "changes", ["before_type"], name: "index_changes_on_before_type", using: :btree

  create_table "page_snapshots", force: :cascade do |t|
    t.integer  "page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "sha2_hash"
    t.text     "html"
    t.string   "text"
  end

  add_index "page_snapshots", ["page_id"], name: "index_page_snapshots_on_page_id", using: :btree
  add_index "page_snapshots", ["sha2_hash"], name: "index_page_snapshots_on_sha2_hash", using: :btree

  create_table "pages", force: :cascade do |t|
    t.text     "name"
    t.text     "url"
    t.text     "css_selector"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "pages", ["user_id"], name: "index_pages_on_user_id", using: :btree

  create_table "slack_integrations", force: :cascade do |t|
    t.string   "channel"
    t.text     "webhook_url"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "sqs_integrations", force: :cascade do |t|
    t.text     "queue_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "watcher_id"
    t.string   "watcher_type"
    t.integer  "watching_id"
    t.string   "watching_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "subscriptions", ["watcher_id"], name: "index_subscriptions_on_watcher_id", using: :btree
  add_index "subscriptions", ["watcher_type"], name: "index_subscriptions_on_watcher_type", using: :btree
  add_index "subscriptions", ["watching_id"], name: "index_subscriptions_on_watching_id", using: :btree
  add_index "subscriptions", ["watching_type"], name: "index_subscriptions_on_watching_type", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "is_admin"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree

end
