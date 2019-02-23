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

ActiveRecord::Schema.define(version: 2019_02_23_221320) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "app_settings", id: :serial, force: :cascade do |t|
    t.string "key"
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_app_settings_on_key"
  end

  create_table "changes", id: :serial, force: :cascade do |t|
    t.integer "before_id"
    t.string "before_type"
    t.integer "after_id"
    t.string "after_type"
    t.text "summary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["after_id"], name: "index_changes_on_after_id"
    t.index ["after_type"], name: "index_changes_on_after_type"
    t.index ["before_id"], name: "index_changes_on_before_id"
    t.index ["before_type"], name: "index_changes_on_before_type"
  end

  create_table "page_snapshots", id: :serial, force: :cascade do |t|
    t.integer "page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sha2_hash"
    t.text "html"
    t.string "text"
    t.index ["page_id"], name: "index_page_snapshots_on_page_id"
    t.index ["sha2_hash"], name: "index_page_snapshots_on_sha2_hash"
  end

  create_table "pages", id: :serial, force: :cascade do |t|
    t.text "name"
    t.text "url"
    t.text "css_selector"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "exclude_selector"
    t.index ["user_id"], name: "index_pages_on_user_id"
  end

  create_table "slack_integrations", id: :serial, force: :cascade do |t|
    t.string "channel"
    t.text "webhook_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sqs_integrations", id: :serial, force: :cascade do |t|
    t.text "queue_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", id: :serial, force: :cascade do |t|
    t.integer "watcher_id"
    t.string "watcher_type"
    t.integer "watching_id"
    t.string "watching_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["watcher_id"], name: "index_subscriptions_on_watcher_id"
    t.index ["watcher_type"], name: "index_subscriptions_on_watcher_type"
    t.index ["watching_id"], name: "index_subscriptions_on_watching_id"
    t.index ["watching_type"], name: "index_subscriptions_on_watching_type"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_admin"
    t.index ["email"], name: "index_users_on_email"
  end

end
