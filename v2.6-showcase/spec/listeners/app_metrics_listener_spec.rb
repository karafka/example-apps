# frozen_string_literal: true

RSpec.describe AppMetricsListener do
  let(:listener) { described_class.new }
  let(:consumer) { karafka.consumer_for(:notifications) }

  # @param payload [Hash]
  def event(payload)
    Karafka::Core::Monitoring::Event.new('test', payload)
  end

  before do
    karafka.produce({ order_id: 1, kind: 'order_confirmed' }.to_json)
    allow(Karafka.logger).to receive(:info)
    allow(Karafka.logger).to receive(:warn)
    allow(Karafka.logger).to receive(:error)
  end

  it 'logs consumed batches' do
    listener.on_consumer_consumed(event(caller: consumer, time: 1.234))

    expect(Karafka.logger).to have_received(:info)
      .with('[metrics] notifications/notifications-0 consumed 1 message(s) in 1.23ms')
  end

  it 'logs messages moved to the DLQ' do
    listener.on_dead_letter_queue_dispatched(event(message: consumer.messages.first))

    expect(Karafka.logger).to have_received(:warn)
      .with('[metrics] notifications/0@0 moved to the DLQ')
  end

  it 'logs errors' do
    listener.on_error_occurred(event(type: 'consumer.consume.error', error: ArgumentError.new))

    expect(Karafka.logger).to have_received(:error)
      .with('[metrics] consumer.consume.error: ArgumentError')
  end
end
