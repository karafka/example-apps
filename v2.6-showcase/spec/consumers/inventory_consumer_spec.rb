# frozen_string_literal: true

RSpec.describe InventoryConsumer do
  let(:consumer) { karafka.consumer_for(:payments) }

  let(:producer) do
    WaterDrop::Producer.new do |config|
      config.kafka = { 'bootstrap.servers': '127.0.0.1:9092', 'transactional.id': 'spec' }
      config.client_class = WaterDrop::Clients::Buffered
    end
  end

  let(:order) do
    Order.create!(customer_id: 'alice', sku: 'mug', quantity: 2, amount_cents: 3_000,
      card: 'valid', status: 'paid')
  end

  let(:payment) { { order_id: order.id, sku: 'mug', quantity: 2 } }

  before do
    Product.create!(sku: 'mug', name: 'Mug', price_cents: 1_500, stock: 10)
    allow(TransactionalProducer).to receive(:instance).and_return(producer)
    karafka.produce(payment.to_json)
  end

  after { producer.close }

  it 'reserves the stock' do
    consumer.consume

    expect(order.reload.reserved).to be(true)
    expect(Product.find_by!(sku: 'mug').stock).to eq(8)
  end

  it 'publishes the inventory event and the notification in one transaction' do
    consumer.consume

    expect(producer.client.messages.map { |message| message[:topic] })
      .to contain_exactly('inventory', 'notifications')
  end

  it 'publishes nothing when the transaction aborts' do
    allow(producer).to receive(:produce_async).and_call_original
    allow(producer).to receive(:produce_async)
      .with(hash_including(topic: 'notifications')).and_raise(WaterDrop::Errors::ProduceError)

    expect { consumer.consume }.to raise_error(WaterDrop::Errors::ProduceError)
    expect(producer.client.messages).to be_empty
  end

  it 'does not reserve twice when the payment is redelivered' do
    karafka.produce(payment.to_json)

    consumer.consume

    expect(Product.find_by!(sku: 'mug').stock).to eq(8)
  end
end
