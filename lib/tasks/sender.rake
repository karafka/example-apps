# frozen_string_literal: true

namespace :waterdrop do
  desc 'Generates messages to Kafka server'
  task :send do
    3.times do
      message = "<message><new>home-#{rand}</new></message>"
      WaterDrop::SyncProducer.call(message, topic: 'xml_data')
    end

    10.times do
      message = { 'number' => rand }.to_json
      # @note You can send messages with async producer as well
      WaterDrop::AsyncProducer.call(message, topic: 'inline_batch_data')
    end

    # Sends the initial ping to start ping-pong within Karafka
    message = { 'counter' => 0 }.to_json
    WaterDrop::SyncProducer.call(message, topic: 'ping')

    message = { rand => rand }.to_json
    WaterDrop::SyncProducer.call(message, topic: 'callbacked_data')
  end
end
