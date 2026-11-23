# frozen_string_literal: true

RSpec.describe ProductsCacheConsumer do
  let(:consumer) { karafka.consumer_for(:products) }

  before do
    Product.create!(sku: 'mug', name: 'Old mug', price_cents: 1_000, stock: 1)

    [
      { sku: 'mug', name: 'Karafka mug', price_cents: 1_500, stock: 100 },
      { sku: 'sticker', name: 'Karafka sticker', price_cents: 300, stock: 1_000 }
    ].each { |product| karafka.produce(product.to_json, key: product[:sku]) }
  end

  it 'upserts the catalog and keeps the stock of known products' do
    consumer.consume

    expect(Product.pluck(:sku, :price_cents, :stock))
      .to contain_exactly(['mug', 1_500, 1], ['sticker', 300, 1_000])
  end

  it 'reports a warm catalog when the end comes without messages' do
    consumer.consume

    expect(Karafka.logger).to receive(:info).with('Catalog warm: 2 product(s) loaded')

    consumer.eofed
  end
end
