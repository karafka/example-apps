# frozen_string_literal: true

RSpec.describe BasicMessagesConsumer do
  let(:logger_service) { double }
  let(:consumer) { described_class.new }

  specify { expect(described_class).to be < ApplicationConsumer }

  describe '#consume' do
    before do
      allow(consumer)
        .to receive(:sleep)
        .with(10)

      allow(LoggerService)
        .to receive(:new)
        .and_return(logger_service)

      allow(logger_service)
        .to receive(:write_to_file)
    end

    it 'logs to file' do
      consumer.consume
    end
  end
end
