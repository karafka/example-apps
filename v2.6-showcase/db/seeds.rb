# frozen_string_literal: true

# The `products` topic is the source of the catalog: the catalog consumer group loads it
[
  { sku: 'mug', name: 'Karafka mug', price_cents: 1_500, stock: 100 },
  { sku: 'tshirt', name: 'Karafka t-shirt', price_cents: 2_500, stock: 50 },
  { sku: 'sticker', name: 'Karafka sticker', price_cents: 300, stock: 1_000 }
].each do |product|
  Karafka.producer.produce_sync(topic: 'products', key: product[:sku], payload: product.to_json)
end
