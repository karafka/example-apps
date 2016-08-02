require 'spec_helper'

RSpec.describe InterchangerMessagesController do
  specify { expect(described_class).to be < ApplicationController }
  let(:logger_service) { double }
  subject(:controller) { described_class.new }

  describe '#perform' do
    it 'logs to file' do
      expect(controller)
        .to receive(:sleep)
        .with(10)

      expect(LoggerService)
        .to receive(:new)
        .and_return(logger_service)

      expect(logger_service)
        .to receive(:write_to_file)

      controller.perform
    end
  end
end
