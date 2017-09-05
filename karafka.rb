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
    config.kafka.seed_brokers = %w[127.0.0.1:9092]
    config.client_id = 'example_app'
  end
end

# Consumer group defined with the 0.6+ routing style (recommended)
App.consumer_groups.draw do
  consumer_group :batched_group do
    # Note that this is not the same as batch_processing
    batch_consuming true

    topic :basic_messages do
      controller BasicMessagesController
      parser XmlParser
    end

    topic :batch_processed_messages do
      controller BatchProcessingController
      batch_processing true
      backend :inline
    end
  end
end

  # Consumer group defined with the 0.5 style
App.consumer_groups.draw do
  topic :aspected_messages do
    controller AspectedMessagesController
    backend :sidekiq
  end

  topic :receiver_message do
    controller ReceiverMessagesController
  end

  topic :interchanger_messages do
    controller InterchangerMessagesController
    interchanger Base64Interchanger
  end

  topic :other_messages do
    controller OtherMessagesController
    worker DifferentWorker
  end
end

App.boot!
