# frozen_string_literal: true

RSpec.describe AspectedMessagesConsumer do
  let(:consumer) { described_class.new }
  let(:logger_service) { double }

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

      allow(consumer)
        .to receive(:respond_with)
        .with('Get my message')
    end

    it 'logs to file' do
      consumer.consume
    end
  end

  describe '#after_failure' do
    before do
      allow(LoggerService)
        .to receive(:new)
        .and_return(logger_service)

      allow(logger_service)
        .to receive(:clear_file)
    end

    it 'clears log file' do
      consumer.after_failure
    end
  end

  describe '#check_params' do
    before do
      allow(consumer)
        .to receive(:params)
        .and_return('message' => '45')
    end
    it 'returns true if message is higher than 30' do
      expect(consumer.send(:check_params)).to be_truthy
    end
  end

  describe '#log_file' do
    let(:path) { rand.to_s }

    before do
      allow(Karafka::App)
        .to receive(:root)
        .and_return(path)
    end

    it { expect(consumer.send(:log_file)).to eq "#{path}/log/aspect_consumer_params.log" }
  end
end
