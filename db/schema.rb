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

ActiveRecord::Schema.define(version: 20150802182136) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "consumers", force: :cascade do |t|
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "deals", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.float    "price"
    t.string   "image"
    t.integer  "threshold"
    t.string   "start_date"
    t.string   "end_date"
    t.string   "status"
    t.integer  "supplier_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "url"
  end

  add_index "deals", ["supplier_id"], name: "index_deals_on_supplier_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "deal_id"
    t.integer  "consumer_id"
    t.string   "token"
    t.integer  "quantity"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "orders", ["consumer_id"], name: "index_orders_on_consumer_id", using: :btree
  add_index "orders", ["deal_id"], name: "index_orders_on_deal_id", using: :btree

  create_table "suppliers", force: :cascade do |t|
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "company_name"
  end

  add_index "suppliers", ["username"], name: "index_suppliers_on_username", unique: true, using: :btree

  add_foreign_key "deals", "suppliers"
  add_foreign_key "orders", "consumers"
  add_foreign_key "orders", "deals"
end
