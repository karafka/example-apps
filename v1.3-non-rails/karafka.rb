# frozen_string_literal: true

# This is a non-Rails example app!
# This file is auto-generated during the install process.
# If by any chance you've wanted a setup for Rails app, either run the `karafka:install`
# command again or refer to the install templates available in the source codes

ENV['RACK_ENV'] ||= 'development'
ENV['KARAFKA_ENV'] ||= ENV['RACK_ENV']
Bundler.require(:default, ENV['KARAFKA_ENV'])

# Zeitwerk custom loader for loading the app components before the whole
# Karafka framework configuration
APP_LOADER = Zeitwerk::Loader.new
APP_LOADER.enable_reloading

%w[
  lib
  app/consumers
  app/responders
  app/workers
  app/middlewares
].each(&APP_LOADER.method(:push_dir))

APP_LOADER.setup
APP_LOADER.eager_load

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
    Karafka.logger.level = ::Logger::INFO

    config.kafka.max_bytes_per_partition = 262_144
    config.kafka.socket_timeout = 300

    config.kafka.start_from_beginning = false
    config.kafka.offset_commit_interval = 5
    config.kafka.offset_commit_threshold = 10
    config.kafka.heartbeat_interval = 10
    config.batch_fetching = true
  end

  monitor.subscribe('app.initialized') do
    WaterDrop.setup { |config| config.deliver = !Karafka.env.test? }
  end
end

# Karafka.monitor.subscribe(Karafka::Instrumentation::StdoutListener.new)


# Consumer group defined with the 0.6+ routing style (recommended)
App.consumer_groups.draw do
  consumer_group :cg_ruby_test_a do

    topic :inline_batch_data do
      consumer InlineBatchConsumer
      batch_consuming true
    end

    topic :callbacked_data do
      consumer CallbackedConsumer
    end
  end

end

Karafka.monitor.subscribe('app.initialized') do
  # Put here all the things you want to do after the Karafka framework
  # initialization
end


App.boot!
