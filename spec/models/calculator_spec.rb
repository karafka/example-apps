# frozen_string_literal: true

RSpec.describe Calculator do
  describe '#sum' do
    let(:calculator) { described_class.new }
    let(:config) { double }

    before do
      calculator.send(:change_value, 10)

      allow(WaterDrop).to receive(:config).and_return(config)
      allow(config).to receive(:send_messages?).and_return(false)
      allow(calculator).to receive(:change_value) { @first_value = calculator.first_value }

      allow(WaterDrop::SyncProducer).to receive(:call)
        .with(
          { args: [5, 10], message: 10 }.to_json,
          topic: 'aspected_messages'
        )

      allow(WaterDrop::SyncProducer).to receive(:call)
        .with(
          { args: [5, 10], message: 25 }.to_json,
          topic: 'aspected_messages'
        )
    end

    it 'counts sum with predefined first argument and sends two messages' do
      expect(calculator.sum(5, 10)).to eq(25)
    end
  end
end
