# frozen_string_literal: true

# Loads the compacted `products` topic into the local catalog
#
# Products are keyed by SKU. A message without a payload (tombstone) deletes the product.
#
# Reaching the end of the partition means the catalog is complete. When the end comes together
# with messages, `#eofed?` is true in `#consume`. When it comes without them, `#eofed` runs.
class ProductsCacheConsumer < ApplicationConsumer
  def consume
    # Only the last state of each SKU in the batch matters
    latest = messages.to_h { |message| [message.key, message.payload] }
    deleted, updated = latest.partition { |_sku, product| product.nil? }

    Product.where(sku: deleted.map(&:first)).delete_all unless deleted.empty?

    rows = updated.filter_map { |sku, product| row(sku, product) }
    # Stock of known products is owned by the inventory flow, the catalog sets it only once
    Product.upsert_all(rows, unique_by: :sku, update_only: %i[name price_cents]) unless rows.empty?

    warm if eofed?
  end

  def eofed
    warm
  end

  private

  # @param sku [String]
  # @param product [Hash] product payload
  # @return [Hash, nil] row to upsert or nil when the product is incomplete
  def row(sku, product)
    unless product['name'] && product['price_cents']
      Karafka.logger.warn("Skipping incomplete product #{sku}")
      return
    end

    {
      sku: sku,
      name: product['name'],
      price_cents: product['price_cents'],
      stock: product.fetch('stock', 0)
    }
  end

  def warm
    Karafka.logger.info("Catalog warm: #{Product.count} product(s) loaded")
  end
end
