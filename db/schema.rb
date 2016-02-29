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

ActiveRecord::Schema.define(version: 20160229155654) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dimensions_dates", force: :cascade do |t|
    t.string   "date",                   null: false
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

  create_table "facts_bookings", force: :cascade do |t|
    t.integer  "dimensions_date_id"
    t.string   "reference_number"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "facts_bookings", ["dimensions_date_id"], name: "index_facts_bookings_on_dimensions_date_id", using: :btree
  add_index "facts_bookings", ["reference_number"], name: "index_facts_bookings_on_reference_number", unique: true, using: :btree

  add_foreign_key "facts_bookings", "dimensions_dates"
end
