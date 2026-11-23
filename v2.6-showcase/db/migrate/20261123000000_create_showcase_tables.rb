# frozen_string_literal: true

# Showcase domain tables
class CreateShowcaseTables < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :sku, null: false, index: { unique: true }
      t.string :name, null: false
      t.integer :price_cents, null: false
      t.integer :stock, null: false, default: 0
      t.timestamps
    end

    create_table :orders do |t|
      t.string :customer_id, null: false
      t.string :sku, null: false
      t.integer :quantity, null: false
      t.integer :amount_cents, null: false
      t.string :card, null: false
      t.string :status, null: false, default: 'pending'
      t.boolean :reserved, null: false, default: false
      t.timestamps
    end

    create_table :notifications do |t|
      t.references :order, null: false
      t.string :kind, null: false
      t.timestamps
    end
    add_index :notifications, %i[order_id kind], unique: true

    create_table :customer_stats do |t|
      t.string :customer_id, null: false, index: { unique: true }
      t.integer :partition, null: false
      t.integer :orders_count, null: false, default: 0
      t.integer :total_cents, null: false, default: 0
      t.timestamps
    end
  end
end
