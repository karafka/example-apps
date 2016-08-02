require 'spec_helper'

RSpec.describe Generator do
  let(:calculator) { double }
  let(:message) { double }
  subject(:generator) { described_class.new }

  describe '#send_messages' do
    before do
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
    end

    it { generator.send_messages }
  end
end
