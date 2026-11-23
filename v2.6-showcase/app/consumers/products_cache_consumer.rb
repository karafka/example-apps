# frozen_string_literal: true

# Loads the compacted `products` topic into the local catalog
#
# Reaching the end of the partition means the catalog is complete. When the end comes together
# with messages, `#eofed?` is true in `#consume`. When it comes without them, `#eofed` runs.
class ProductsCacheConsumer < ApplicationConsumer
  def consume
    rows = messages.map do |message|
      message.payload.slice('sku', 'name', 'price_cents', 'stock')
    end

    # Stock of known products is owned by the inventory flow, the catalog sets it only once
    Product.upsert_all(rows, unique_by: :sku, update_only: %i[name price_cents])

    warm if eofed?
  end

  def eofed
    warm
  end

  private

  def warm
    Karafka.logger.info("Catalog warm: #{Product.count} product(s) loaded")
  end
end
