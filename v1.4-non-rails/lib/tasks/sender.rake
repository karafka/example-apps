# frozen_string_literal: true

namespace :waterdrop do
  desc 'Generates messages to Kafka server'
  task :send do
    message = { 'counter' => 0 }.to_json
    WaterDrop::SyncProducer.call(message, topic: 'ping')
  end
end
