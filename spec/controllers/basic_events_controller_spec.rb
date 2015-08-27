require 'spec_helper'

RSpec.describe BasicEventsController do
  let(:logger_service) { double }

  describe '#perform' do
    it 'logs to file' do
      allow_any_instance_of(described_class)
        .to receive(:sleep)
        .with(10)

      expect(LoggerService)
        .to receive(:new)
        .and_return(logger_service)

      expect(logger_service)
        .to receive(:write_to_file)

      subject.perform
    end
  end
end
