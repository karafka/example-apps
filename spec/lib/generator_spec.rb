require 'spec_helper'

RSpec.describe Generator do
  let(:calculator) { double }
  let(:message) { double }

  describe '#send_messages' do
    it 'sends messages' do
      expect(Calculator)
        .to receive(:new)
        .and_return(calculator)

      expect(calculator)
        .to receive(:sum)
        .with(5, 6)

      expect(WaterDrop::Message)
        .to receive(:new)
        .twice
        .and_return(message)

      expect(message)
        .to receive(:send!)
        .twice

      subject.send_messages
    end
  end
end
