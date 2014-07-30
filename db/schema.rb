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

ActiveRecord::Schema.define(version: 20140727021154) do

  create_table "comics", force: true do |t|
    t.string   "path"
    t.boolean  "aozora"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "left"
    t.string   "file_type"
  end

  add_index "comics", ["path"], name: "index_comics_on_path"

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "image_caches", force: true do |t|
    t.integer  "page_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "image_caches", ["created_at"], name: "index_image_caches_on_created_at"
  add_index "image_caches", ["page_id"], name: "index_image_caches_on_page_id"

  create_table "memos", force: true do |t|
    t.integer  "page_id"
    t.string   "user_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memos", ["page_id", "user_id"], name: "index_memos_on_page_id_and_user_id"

  create_table "pages", force: true do |t|
    t.integer  "comic_id"
    t.integer  "page"
    t.boolean  "portlait"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "name",       limit: 255
    t.text     "memo"
  end

  add_index "pages", ["comic_id"], name: "index_pages_on_comic_id"
  add_index "pages", ["page"], name: "index_pages_on_page"

  create_table "recent_aozoras", force: true do |t|
    t.integer  "comic_id"
    t.integer  "page"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_id"
  end

  add_index "recent_aozoras", ["comic_id"], name: "index_recent_aozoras_on_comic_id"
  add_index "recent_aozoras", ["user_id"], name: "index_recent_aozoras_on_user_id"

  create_table "recent_txts", force: true do |t|
    t.integer  "comic_id"
    t.integer  "page"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_id"
  end

  add_index "recent_txts", ["comic_id"], name: "index_recent_txts_on_comic_id"
  add_index "recent_txts", ["user_id"], name: "index_recent_txts_on_user_id"

  create_table "recents", force: true do |t|
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_id"
  end

  add_index "recents", ["page_id"], name: "index_recents_on_page_id"
  add_index "recents", ["user_id"], name: "index_recents_on_user_id"

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

  create_table "settings", force: true do |t|
    t.string   "cache_path_prefix"
    t.string   "cache_path_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
