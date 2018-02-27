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
    # Karafka will autodiscover kafka_hosts based on Zookeeper but we need it set manually
    # to run tests without running kafka and zookeper
    config.kafka.seed_brokers = %w[kafka://172.17.0.3:9092]
    config.client_id = 'example_app'
  end
end

Karafka.monitor.subscribe(Karafka::Instrumentation::Listener)

# Consumer group defined with the 0.6+ routing style (recommended)
App.consumer_groups.draw do
  consumer_group :batched_group do
    # Note that this is not the same as batch_consuming
    batch_fetching true

    topic :basic_messages do
      consumer BasicMessagesConsumer
      parser XmlParser
    end

    topic :batch_processed_messages do
      consumer BatchProcessingConsumer
      batch_consuming true
      backend :inline
    end
  end
end

# Consumer group defined with the 0.5 style
App.consumer_groups.draw do
  topic :aspected_messages do
    consumer AspectedMessagesConsumer
    backend :sidekiq
  end

  topic :receiver_message do
    consumer ReceiverMessagesConsumer
  end

  topic :interchanger_messages do
    consumer InterchangerMessagesConsumer
    interchanger Base64Interchanger
  end

  topic :other_messages do
    consumer OtherMessagesConsumer
    worker DifferentWorker
  end
end

App.boot!
