# frozen_string_literal: true

RSpec.describe PaymentsConsumer do
  let(:consumer) { karafka.consumer_for(:orders, :payments) }

  let(:order) do
    Order.create!(customer_id: 'alice', sku: 'mug', quantity: 2, amount_cents: 3_000, card: card)
  end

  let(:payments) { karafka.produced_messages.select { |message| message[:topic] == 'payments' } }

  before { karafka.produce(order.event.to_json, key: order.customer_id) }

  context 'when the card is charged' do
    let(:card) { 'valid' }

    it 'marks the order paid, publishes the payment and marks the offset' do
      expect(consumer).to receive(:mark_as_consumed).and_call_original

      consumer.consume

      expect(order.reload.status).to eq('paid')
      expect(payments.size).to eq(1)
      expect(JSON.parse(payments.first[:payload]))
        .to include('order_id' => order.id, 'payment_id' => "pay_#{order.id}")
    end
  end

  context 'when the card is declined' do
    let(:card) { 'declined' }

    it 'raises so the message is retried and then moved to the DLQ' do
      expect { consumer.consume }.to raise_error(PaymentGateway::Declined)
      expect(order.reload.status).to eq('pending')
      expect(payments).to be_empty
    end
  end

  context 'when the gateway is unavailable' do
    let(:card) { 'unavailable' }

    it 'pauses on the message without marking it' do
      expect(consumer).to receive(:pause).with(0, described_class::BACKOFF_MS)
      expect(consumer).not_to receive(:mark_as_consumed)

      consumer.consume

      expect(order.reload.status).to eq('pending')
    end
  end
end
