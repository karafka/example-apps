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

ActiveRecord::Schema[8.1].define(version: 2026_11_23_000000) do
  create_table "customer_stats", force: :cascade do |t|
    t.string "customer_id", null: false
    t.integer "partition", null: false
    t.integer "orders_count", default: 0, null: false
    t.integer "total_cents", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_customer_stats_on_customer_id", unique: true
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "order_id", null: false
    t.string "kind", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id", "kind"], name: "index_notifications_on_order_id_and_kind", unique: true
    t.index ["order_id"], name: "index_notifications_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "customer_id", null: false
    t.string "sku", null: false
    t.integer "quantity", null: false
    t.integer "amount_cents", null: false
    t.string "card", null: false
    t.string "status", default: "pending", null: false
    t.boolean "reserved", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "sku", null: false
    t.string "name", null: false
    t.integer "price_cents", null: false
    t.integer "stock", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sku"], name: "index_products_on_sku", unique: true
  end
end
