# frozen_string_literal: true

RSpec.describe InlineBatchConsumer do
  subject(:consumer) { described_class.new }

  let(:nr1_value) { rand }
  let(:nr2_value) { rand }
  let(:nr1) { { 'number' => nr1_value }.to_json }
  let(:nr2) { { 'number' => nr2_value }.to_json }
  let(:sum) { nr1_value + nr2_value }

  before do
    consumer.params_batch = [{ 'value' => nr1 }, { 'value' => nr2 }]
    allow(Karafka.logger).to receive(:info)
  end

  it 'expects to log a proper message' do
    expect(Karafka.logger).to receive(:info).with("Sum of 2 elements equals to: #{sum}")
    consumer.consume
  end
end
