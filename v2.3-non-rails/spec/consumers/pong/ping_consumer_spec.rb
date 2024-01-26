# frozen_string_literal: true

RSpec.describe Pong::PingConsumer do
  subject(:consumer) { karafka.consumer_for(:ping) }

  context 'when we receive a message' do
    before { karafka.produce({ 'hits' => 0 }.to_json) }

    it 'expect to dispatch a pong message with counter back' do
      consumer.consume

      expect(karafka.produced_messages.last[:payload]).to eq({ hits: 1 }.to_json)
    end
  end
end
