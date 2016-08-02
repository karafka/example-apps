require 'spec_helper'

RSpec.describe AspectedMessagesController do
  specify { expect(described_class).to be < ApplicationController }
  subject(:controller) { described_class.new }
  let(:logger_service) { double }

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

  describe '#after_failure' do
    it 'clears log file' do
      expect(LoggerService)
        .to receive(:new)
        .and_return(logger_service)

      expect(logger_service)
        .to receive(:clear_file)

      controller.after_failure
    end
  end

  describe '#check_params' do
    before do
      expect(controller)
        .to receive(:params)
        .and_return('message' => '45')
    end
    it 'returns true if message is higher than 30' do
      expect(controller.send(:check_params)).to be_truthy
    end
  end

  describe '#log_file' do
    let(:path) { rand.to_s }

    before do
      expect(Karafka::App)
        .to receive(:root)
        .and_return(path)
    end

    it { expect(controller.send(:log_file)).to eq "#{path}/log/aspect_controller_params.log" }
  end
end
