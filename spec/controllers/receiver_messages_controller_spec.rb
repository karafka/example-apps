require 'spec_helper'

RSpec.describe ReceiverMessagesController do
  specify { expect(described_class).to be < ApplicationController }
  let(:logger_service) { double }
  let(:controller) { described_class.new }

  describe '#perform' do
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
      controller.perform
    end
  end
end
