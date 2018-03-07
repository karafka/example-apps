# frozen_string_literal: true

RSpec.describe Pong::PongResponder do
  subject(:responder) { described_class.new }

  specify { expect(described_class.ancestors).to include ApplicationResponder }

  it { expect(described_class.topics.size).to eq 1 }

  describe 'supported topics' do
    describe 'ping' do
      let(:topic) { described_class.topics['ping'] }

      it { expect(topic.name).to eq 'ping' }
      it { expect(topic.required?).to be true }
      it { expect(topic.multiple_usage?).to be false }
    end
  end

  describe '#respond' do
    let(:input_data) { { rand => rand } }

    let(:accumulated_data) do
      [[input_data.to_json, { topic: 'ping' }]]
    end

    it 'expect to add builds to message buffer' do
      responder.respond(input_data)
      expect(responder.messages_buffer['ping']).to eq accumulated_data
    end
  end
end
