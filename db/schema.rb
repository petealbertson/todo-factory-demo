# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_03_000645) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "notes", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.bigint "todo_id", null: false
    t.datetime "updated_at", null: false
    t.index ["todo_id"], name: "index_notes_on_todo_id"
  end

  create_table "tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.bigint "todo_id", null: false
    t.datetime "updated_at", null: false
    t.index ["todo_id"], name: "index_tags_on_todo_id"
  end

  create_table "todos", force: :cascade do |t|
    t.boolean "completed"
    t.datetime "created_at", null: false
    t.date "due_date"
    t.string "priority", default: "medium", null: false
    t.string "title"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "notes", "todos"
end
