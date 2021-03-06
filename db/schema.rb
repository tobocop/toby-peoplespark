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

ActiveRecord::Schema.define(version: 20150302051526) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "idea_votes", force: :cascade do |t|
    t.integer  "idea_id"
    t.integer  "user_id"
    t.integer  "vote_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ideas", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.boolean  "single_office"
    t.boolean  "anonymous"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "aasm_state"
    t.integer  "user_id"
    t.integer  "office_id"
  end

  create_table "offices", force: :cascade do |t|
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.integer  "office_id"
    t.string   "profile_picture"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
