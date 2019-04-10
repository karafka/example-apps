# frozen_string_literal: true

# Non Ruby on Rails setup
ENV['RACK_ENV'] ||= 'development'
ENV['KARAFKA_ENV'] ||= ENV['RACK_ENV']
Bundler.require(:default, ENV['KARAFKA_ENV'])
Karafka::Loader.load(Karafka::App.root)

# App class
# @note The whole setup and routing could be placed in a single class definition
#   but we wanted to show you, that in case of bigger applications, you can create
#   a structure similar to rails config/routes.rb, etc.
class App < Karafka::App
  setup do |config|
    # Karafka will auto-discover kafka_hosts based on Zookeeper but we need it set manually
    # to run tests without running kafka and zookeeper
    config.kafka.seed_brokers = [ENV['KAFKA_HOST'] || 'kafka://127.0.0.1:9092']
    config.client_id = 'example_app'
  end

  monitor.subscribe('app.initialized') do
    WaterDrop.setup { |config| config.deliver = !Karafka.env.test? }
  end
end

Karafka.monitor.subscribe(WaterDrop::Instrumentation::StdoutListener.new)
Karafka.monitor.subscribe(Karafka::Instrumentation::StdoutListener.new)
Karafka.monitor.subscribe(Karafka::Instrumentation::ProctitleListener.new)

# Consumer group defined with the 0.6+ routing style (recommended)
App.consumer_groups.draw do
  consumer_group :batched_group do
    batch_fetching true

    topic :xml_data do
      consumer XmlMessagesConsumer
      batch_consuming false
      deserializer XmlDeserializer.new
    end

    topic :inline_batch_data do
      consumer InlineBatchConsumer
      batch_consuming true
    end

    topic :callbacked_data do
      consumer CallbackedConsumer
      batch_consuming true
    end
  end

  # A ping-pong implementation using karafka-sidekiq backend
  # @note The backend is totally optional, if you disable it, the game will
  # work as well
  consumer_group :async_pong do
    topic :ping do
      consumer Pong::PingConsumer
      backend :sidekiq
    end

    topic :pong do
      consumer Pong::PongConsumer
      backend :sidekiq
    end
  end
end

App.boot!
