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

ActiveRecord::Schema.define(version: 2023_07_13_195107) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendees", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email_address"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "events", force: :cascade do |t|
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.text "description", null: false
    t.integer "event_type", default: 0, null: false
    t.boolean "private", default: false, null: false
    t.string "title", limit: 75, default: ""
    t.text "location", default: ""
    t.bigint "organizer_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organizer_id"], name: "index_events_on_organizer_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.bigint "attendee_id"
    t.bigint "event_id"
    t.integer "invitation_status", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["attendee_id"], name: "index_invitations_on_attendee_id"
    t.index ["event_id"], name: "index_invitations_on_event_id"
  end

  create_table "organizers", force: :cascade do |t|
    t.string "email_address"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "events", "organizers", on_delete: :cascade
  add_foreign_key "invitations", "attendees", on_delete: :cascade
  add_foreign_key "invitations", "events", on_delete: :cascade
end
