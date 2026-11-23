# frozen_string_literal: true

RSpec.describe OrderStatsConsumer do
  let(:consumer) { karafka.consumer_for(:orders, :analytics) }

  before do
    [1_500, 2_500].each do |amount|
      karafka.produce({ customer_id: 'alice', amount_cents: amount }.to_json, key: 'alice')
    end
  end

  it 'builds per-customer totals' do
    consumer.consume

    stat = CustomerStat.find_by!(customer_id: 'alice')
    expect(stat.orders_count).to eq(2)
    expect(stat.total_cents).to eq(4_000)
    expect(stat.partition).to eq(0)
  end

  context 'when a replay is requested' do
    let(:replay_from) { '2026-11-23T00:00:00Z' }

    before do
      ENV['REPLAY_FROM'] = replay_from
      CustomerStat.create!(customer_id: 'alice', partition: 0, orders_count: 10, total_cents: 1)
      CustomerStat.create!(customer_id: 'bob', partition: 1, orders_count: 3, total_cents: 1)
    end

    after { ENV.delete('REPLAY_FROM') }

    it 'drops the totals and seeks back to the given time once' do
      expect(consumer).to receive(:seek).with(Time.parse(replay_from)).once

      consumer.consume
      expect(CustomerStat.pluck(:customer_id)).to eq(['bob'])

      consumer.consume
      expect(CustomerStat.find_by!(customer_id: 'alice').orders_count).to eq(2)
    end
  end
end
