# frozen_string_literal: true

RSpec.describe Pong::PingConsumer do
  subject(:consumer) { karafka.consumer_for(:ping) }

  context 'when we receive a message' do
    before { karafka.publish({ 'hits' => 0 }.to_json) }

    it 'expect to dispatch a pong message with counter back' do
      expect(consumer.producer)
        .to receive(:produce_async)
        .with(topic: 'pong', payload: { hits: 1 }.to_json)

      consumer.consume
    end
  end
end
