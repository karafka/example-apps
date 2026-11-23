# frozen_string_literal: true

RSpec.describe OrdersController do
  let(:session) { ActionDispatch::Integration::Session.new(Rails.application) }
  let(:orders) { karafka.produced_messages.select { |message| message[:topic] == 'orders' } }

  before { Product.create!(sku: 'mug', name: 'Mug', price_cents: 1_500, stock: 10) }

  it 'creates the order and publishes it keyed by customer' do
    session.post('/orders', params: { customer_id: 'alice', sku: 'mug', quantity: '2' })

    expect(session.response.status).to eq(201)
    expect(Order.last.amount_cents).to eq(3_000)
    expect(orders.size).to eq(1)
    expect(orders.first[:key]).to eq('alice')
  end

  %w[-5 0 abc 1.5].each do |quantity|
    it "rejects quantity #{quantity}" do
      session.post('/orders', params: { customer_id: 'alice', sku: 'mug', quantity: quantity })

      expect(session.response.status).to eq(422)
      expect(Order.count).to eq(0)
      expect(orders).to be_empty
    end
  end
end
