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

ActiveRecord::Schema.define(version: 20171231045409) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "exchanges", force: :cascade do |t|
    t.integer "chat_id"
    t.string "chat_title"
    t.boolean "is_set"
  end

  create_table "participants", force: :cascade do |t|
    t.bigint "exchange_id"
    t.integer "user_id"
    t.text "profile"
    t.boolean "is_set"
    t.index ["exchange_id"], name: "index_participants_on_exchange_id"
    t.index ["user_id"], name: "index_participants_on_user_id", unique: true
  end

  create_table "updates", force: :cascade do |t|
    t.integer "update_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
