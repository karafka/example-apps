# frozen_string_literal: true

RSpec.describe Pong::PingResponder do
  subject(:responder) { described_class.new }

  it { expect(described_class.topics.size).to eq 1 }

  describe 'supported topics' do
    describe 'pong' do
      let(:topic) { described_class.topics['pong'] }

      it { expect(topic.name).to eq 'pong' }
      it { expect(topic.required?).to be true }
      it { expect(topic.multiple_usage?).to be false }
    end
  end

  describe '#call' do
    let(:input_data) { { rand => rand } }

    let(:accumulated_data) do
      [[input_data.to_json, { topic: 'pong' }]]
    end

    it 'expect to add builds to message buffer' do
      responder.call(input_data)
      expect(responder.messages_buffer['pong']).to eq accumulated_data
    end

    context 'when we try to use same responder more than once' do
      let(:error) { Karafka::Errors::InvalidResponderUsage }

      it 'expects to raise an error since its not a multiple usage responder' do
        expect { 2.times { responder.call(input_data) } }.to raise_error error
      end
    end
  end
end
