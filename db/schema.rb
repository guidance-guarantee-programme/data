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

ActiveRecord::Schema.define(version: 20160419145501) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dimensions_audits", force: :cascade do |t|
    t.string   "fact_table",                   null: false
    t.string   "source",                       null: false
    t.string   "source_type",                  null: false
    t.integer  "inserted_records", default: 0
    t.jsonb    "log"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "dimensions_dates", force: :cascade do |t|
    t.date     "date",                   null: false
    t.string   "date_name",              null: false
    t.string   "date_name_abbreviated",  null: false
    t.integer  "year",                   null: false
    t.integer  "quarter",                null: false
    t.integer  "month",                  null: false
    t.string   "month_name",             null: false
    t.string   "month_name_abbreviated", null: false
    t.integer  "week",                   null: false
    t.integer  "day_of_year",            null: false
    t.integer  "day_of_quarter",         null: false
    t.integer  "day_of_month",           null: false
    t.integer  "day_of_week",            null: false
    t.string   "day_name",               null: false
    t.string   "day_name_abbreviated",   null: false
    t.string   "weekday_weekend",        null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "dimensions_dates", ["date"], name: "index_dimensions_dates_on_date", unique: true, using: :btree
  add_index "dimensions_dates", ["date_name"], name: "index_dimensions_dates_on_date_name", unique: true, using: :btree
  add_index "dimensions_dates", ["date_name_abbreviated"], name: "index_dimensions_dates_on_date_name_abbreviated", unique: true, using: :btree

  create_table "dimensions_outcomes", force: :cascade do |t|
    t.string   "name"
    t.boolean  "successful", default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "dimensions_outcomes", ["name"], name: "index_dimensions_outcomes_on_name", unique: true, using: :btree

  create_table "dimensions_states", force: :cascade do |t|
    t.string   "name",       null: false
    t.boolean  "default"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dimensions_times", force: :cascade do |t|
    t.integer  "minute_of_day"
    t.integer  "minute_of_hour"
    t.integer  "hour"
    t.string   "timezone"
    t.string   "day_part"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "dimensions_times", ["day_part"], name: "index_dimensions_times_on_day_part", using: :btree
  add_index "dimensions_times", ["hour"], name: "index_dimensions_times_on_hour", using: :btree
  add_index "dimensions_times", ["minute_of_day"], name: "index_dimensions_times_on_minute_of_day", unique: true, using: :btree

  create_table "facts_appointments", force: :cascade do |t|
    t.integer  "dimensions_date_id"
    t.string   "reference_number"
    t.string   "reference_updated_at"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "dimensions_audit_id"
    t.integer  "dimensions_state_id"
  end

  add_index "facts_appointments", ["dimensions_date_id"], name: "index_facts_appointments_on_dimensions_date_id", using: :btree
  add_index "facts_appointments", ["reference_number"], name: "index_facts_appointments_on_reference_number", unique: true, using: :btree

  create_table "facts_bookings", force: :cascade do |t|
    t.integer  "dimensions_date_id"
    t.string   "reference_number"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "dimensions_audit_id"
    t.integer  "lead_time"
  end

  add_index "facts_bookings", ["dimensions_date_id"], name: "index_facts_bookings_on_dimensions_date_id", using: :btree
  add_index "facts_bookings", ["reference_number"], name: "index_facts_bookings_on_reference_number", unique: true, using: :btree

  create_table "facts_calls", force: :cascade do |t|
    t.integer  "dimensions_audit_id"
    t.integer  "dimensions_date_id"
    t.integer  "dimensions_time_id"
    t.integer  "dimensions_outcome_id"
    t.integer  "call_time"
    t.integer  "talk_time"
    t.integer  "ring_time"
    t.float    "cost"
    t.string   "reference_number"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "facts_calls", ["dimensions_audit_id"], name: "index_facts_calls_on_dimensions_audit_id", using: :btree
  add_index "facts_calls", ["dimensions_date_id"], name: "index_facts_calls_on_dimensions_date_id", using: :btree
  add_index "facts_calls", ["dimensions_outcome_id"], name: "index_facts_calls_on_dimensions_outcome_id", using: :btree
  add_index "facts_calls", ["dimensions_time_id"], name: "index_facts_calls_on_dimensions_time_id", using: :btree

  create_table "facts_cancelled_bookings", force: :cascade do |t|
    t.integer  "dimensions_date_id"
    t.integer  "lead_time"
    t.integer  "delay_time"
    t.string   "reference_number"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "facts_cancelled_bookings", ["dimensions_date_id"], name: "index_facts_cancelled_bookings_on_dimensions_date_id", using: :btree
  add_index "facts_cancelled_bookings", ["reference_number"], name: "index_facts_cancelled_bookings_on_reference_number", unique: true, using: :btree

  add_foreign_key "facts_appointments", "dimensions_dates"
  add_foreign_key "facts_bookings", "dimensions_dates"
  add_foreign_key "facts_calls", "dimensions_audits"
  add_foreign_key "facts_calls", "dimensions_dates"
  add_foreign_key "facts_calls", "dimensions_outcomes"
  add_foreign_key "facts_calls", "dimensions_times"
  add_foreign_key "facts_cancelled_bookings", "dimensions_dates"
end
