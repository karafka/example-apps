# frozen_string_literal: true

RSpec.describe Pong::PongConsumer do
  subject(:consumer) { karafka.consumer_for(:pong) }

  context 'when we receive a message' do
    before { karafka.publish({ 'hits' => 1 }.to_json) }

    it 'expect to dispatch a ping message with counter back' do
      expect(consumer.producer)
        .to receive(:produce_async)
        .with(topic: 'ping', payload: { hits: 2 }.to_json)

      consumer.consume
    end
  end
end
