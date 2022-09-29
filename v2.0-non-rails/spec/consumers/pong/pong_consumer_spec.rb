# frozen_string_literal: true

RSpec.describe Pong::PongConsumer do
  subject(:consumer) { karafka.consumer_for(:pong) }

  context 'when we receive a message' do
    before { karafka.produce({ 'hits' => 1 }.to_json) }

    it 'expect to dispatch a ping message with counter back' do
      consumer.consume

      expect(karafka.produced_messages.last[:payload]).to eq({ hits: 2 }.to_json)
    end
  end
end
