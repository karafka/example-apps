# frozen_string_literal: true

RSpec.describe PaymentGateway do
  it 'charges a valid card' do
    expect(described_class.charge(order_id: 1, card: 'valid', amount_cents: 100)).to eq('pay_1')
  end

  it 'declines a declined card every time' do
    2.times do
      expect { described_class.charge(order_id: 2, card: 'declined', amount_cents: 100) }
        .to raise_error(described_class::DeclinedError)
    end
  end

  it 'fails during the outage and then charges' do
    order_id = SecureRandom.random_number(1_000_000)

    expect { described_class.charge(order_id: order_id, card: 'unavailable', amount_cents: 1) }
      .to raise_error(described_class::UnavailableError)
    expect(described_class.charge(order_id: order_id, card: 'unavailable', amount_cents: 1))
      .to eq("pay_#{order_id}")
  end
end
