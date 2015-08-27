require 'spec_helper'

RSpec.describe Calculator do
  describe '#sum' do
    let(:message) { double }
    before do
      subject.send(:change_value, 10)
      allow(WaterDrop)
        .to receive_message_chain(:config, :send_messages?)
        .and_return(false)

      allow(subject)
        .to receive(:change_value) { @first_value = subject.first_value }

      expect(WaterDrop::Message).to receive(:new)
        .with('aspected_messages',
              topic: 'aspected_messages',
              method: :sum,
              message: 10,
              args: [5, 10])
        .and_return(message)

      expect(WaterDrop::Message).to receive(:new)
        .with('aspected_messages',
              topic: 'aspected_messages',
              method: :sum,
              message: 25,
              args: [5, 10])
        .and_return(message)

      expect(message).to receive(:send!).twice
    end
    it 'counts sum with predefined first argument and sends two messages' do
      expect(subject.sum(5, 10)).to eq(25)
    end
  end
end
