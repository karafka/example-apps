# frozen_string_literal: true

RSpec.describe NotificationsConsumer do
  let(:consumer) { karafka.consumer_for(:notifications) }

  let(:order) do
    Order.create!(customer_id: 'alice', sku: 'mug', quantity: 1, amount_cents: 1_500,
      card: 'valid')
  end

  before { 2.times { karafka.produce({ order_id: order.id, kind: 'order_confirmed' }.to_json) } }

  it 'records each notification once' do
    expect { consumer.consume }.to change(Notification, :count).by(1)
  end
end
