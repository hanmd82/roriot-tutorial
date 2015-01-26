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

ActiveRecord::Schema.define(version: 20150126081230) do

  create_table "measurements", force: :cascade do |t|
    t.string   "type",            limit: 255
    t.integer  "node_id",         limit: 4
    t.integer  "node_guid",       limit: 4
    t.integer  "recorded_at",     limit: 4
    t.integer  "sequence_number", limit: 4
    t.text     "data",            limit: 65535
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "measurements", ["node_id", "recorded_at"], name: "index_measurements_on_node_id_and_recorded_at", using: :btree
  add_index "measurements", ["node_id"], name: "index_measurements_on_node_id", using: :btree

  create_table "nodes", force: :cascade do |t|
    t.integer  "guid",        limit: 4
    t.string   "label",       limit: 255
    t.decimal  "lat",                       precision: 9, scale: 6
    t.decimal  "lng",                       precision: 9, scale: 6
    t.text     "description", limit: 65535
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  add_index "nodes", ["guid"], name: "index_nodes_on_guid", unique: true, using: :btree

  add_foreign_key "measurements", "nodes"
end
