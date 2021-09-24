# frozen_string_literal: true

# This is a non-Rails example app!

ENV['KARAFKA_ENV'] ||= 'development'
Bundler.require(:default, ENV['KARAFKA_ENV'])

# Zeitwerk custom loader for loading the app components before the whole
# Karafka framework configuration
APP_LOADER = Zeitwerk::Loader.new

%w[
  lib
  app/consumers
].each(&APP_LOADER.method(:push_dir))

APP_LOADER.setup
APP_LOADER.eager_load

# App class
class App < Karafka::App
  setup do |config|
    config.concurrency = 5
    config.max_wait_time = 1_000
    config.kafka = { 'bootstrap.servers' => ENV['KAFKA_HOST'] || '127.0.0.1:9092' }
  end
end

Karafka.producer.monitor.subscribe(WaterDrop::Instrumentation::StdoutListener.new(Karafka.logger))
Karafka.monitor.subscribe(Karafka::Instrumentation::StdoutListener.new)
Karafka.monitor.subscribe(Karafka::Instrumentation::ProctitleListener.new)

App.consumer_groups.draw do
  consumer_group :batched_group do
    topic :xml_data do
      consumer XmlMessagesConsumer
      deserializer XmlDeserializer.new
    end

    topic :counters do
      consumer CountersConsumer
    end

    topic :ping do
      consumer Pong::PingConsumer
    end

    topic :pong do
      consumer Pong::PongConsumer
    end
  end
end
