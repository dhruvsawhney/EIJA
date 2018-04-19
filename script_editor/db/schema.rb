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

ActiveRecord::Schema.define(version: 20180412061335) do

  create_table "acts", force: :cascade do |t|
    t.integer  "number"
    t.integer  "play_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["play_id"], name: "index_acts_on_play_id"
  end

  create_table "cuts", force: :cascade do |t|
    t.integer  "edit_id"
    t.integer  "word_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["edit_id"], name: "index_cuts_on_edit_id"
    t.index ["word_id"], name: "index_cuts_on_word_id"
  end

  create_table "edits", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "play_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "groups_id"
    t.index ["groups_id"], name: "index_edits_on_groups_id"
  end

  create_table "groups", force: :cascade do |t|
    t.integer  "groupNum"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "user_id"
    t.string   "name",       default: ""
    t.index ["user_id"], name: "index_groups_on_user_id"
  end

  create_table "line_cuts", force: :cascade do |t|
    t.integer  "edit_id"
    t.integer  "line_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["edit_id"], name: "index_line_cuts_on_edit_id"
    t.index ["line_id"], name: "index_line_cuts_on_line_id"
  end

  create_table "lines", force: :cascade do |t|
    t.integer  "number"
    t.integer  "scene_id"
    t.string   "speaker"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "isStage",    default: false
    t.integer  "currLength"
    t.index ["scene_id"], name: "index_lines_on_scene_id"
  end

  create_table "plays", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "category"
  end

  create_table "scenes", force: :cascade do |t|
    t.integer  "number"
    t.integer  "act_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["act_id"], name: "index_scenes_on_act_id"
  end

  create_table "uncuts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "edit_id"
    t.integer  "word_id"
    t.index ["edit_id"], name: "index_uncuts_on_edit_id"
    t.index ["word_id"], name: "index_uncuts_on_word_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "user_name"
    t.string   "major"
    t.integer  "grad_year"
    t.boolean  "enrolled"
    t.boolean  "admin",                  default: false
    t.integer  "groups_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["groups_id"], name: "index_users_on_groups_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "words", force: :cascade do |t|
    t.string   "text"
    t.integer  "line_id"
    t.integer  "place"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["line_id"], name: "index_words_on_line_id"
  end

end
