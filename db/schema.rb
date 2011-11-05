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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111015062141) do

  create_table "comics", :force => true do |t|
    t.string   "path"
    t.boolean  "aozora"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "left"
    t.string   "file_type"
  end

  add_index "comics", ["path"], :name => "index_comics_on_path"

  create_table "pages", :force => true do |t|
    t.integer  "comic_id"
    t.integer  "page"
    t.boolean  "portlait"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "name"
  end

  add_index "pages", ["comic_id"], :name => "index_pages_on_comic_id"
  add_index "pages", ["page"], :name => "index_pages_on_page"

  create_table "recents", :force => true do |t|
    t.integer  "page_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recents", ["page_id"], :name => "index_recents_on_page_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

end
