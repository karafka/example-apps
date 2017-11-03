# frozen_string_literal: true

RSpec.describe ReceiverMessagesController do
  let(:logger_service) { double }
  let(:controller) { described_class.new }

  specify { expect(described_class).to be < ApplicationController }

  describe '#consume' do
    before do
      allow(controller)
        .to receive(:sleep)
        .with(10)

      allow(LoggerService)
        .to receive(:new)
        .and_return(logger_service)

      allow(logger_service)
        .to receive(:write_to_file)
    end

    it 'logs to file' do
      controller.consume
    end
  end
end
