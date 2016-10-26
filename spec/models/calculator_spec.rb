require 'spec_helper'

RSpec.describe Calculator do
  describe '#sum' do
    let(:calculator) { described_class.new }
    let(:message) { double }
    let(:config) { double }

    before do
      calculator.send(:change_value, 10)

      allow(WaterDrop)
        .to receive(:config)
        .and_return(config)

      allow(config)
        .to receive(:send_messages?)
        .and_return(false)

      allow(calculator)
        .to receive(:change_value) { @first_value = calculator.first_value }

      allow(WaterDrop::Message).to receive(:new)
        .with(
          'aspected_messages',
          {
            args: [5, 10],
            message: 10
          }.to_json
        )
        .and_return(message)

      allow(WaterDrop::Message).to receive(:new)
        .with(
          'aspected_messages',
          {
            args: [5, 10],
            message: 25
          }.to_json
        )
        .and_return(message)

      allow(message).to receive(:send!).twice
    end

    it 'counts sum with predefined first argument and sends two messages' do
      expect(calculator.sum(5, 10)).to eq(25)
    end
  end
end
