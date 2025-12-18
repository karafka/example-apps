# frozen_string_literal: true

# Match repro karafka.rb configuration
require 'datadog/statsd'

SWARM_MODE_ENABLED = ENV.fetch('KARAFKA_SWARM_MODE_ENABLED', 'false') == 'true'
DEFAULT_SWARM_NODES = ENV.fetch('KARAFKA_SWARM_NODES', '2').to_i

# Karafka app object
class KarafkaApp < Karafka::App
  setup do |config|
    config.client_id = 'example_app'
    config.initial_offset = 'latest'
    config.shutdown_timeout = ENV.fetch('KARAFKA_CONSUMER_SHUTDOWN_TIMEOUT', '15').to_i * 1000
    config.concurrency = ENV.fetch('KARAFKA_CONSUMER_CONCURRENCY', '1').to_i
    config.max_messages = ENV.fetch('KARAFKA_CONSUMER_MAX_MESSAGES', '100').to_i
    config.max_wait_time = 500

    # Swarm mode from repro
    if SWARM_MODE_ENABLED
      config.swarm.nodes = [DEFAULT_SWARM_NODES, 1].max
      puts "Swarm nodes: #{config.swarm.nodes}"
    end

    # Recreate consumers with each batch for dev code reload
    config.consumer_persistence = !Rails.env.development?

    # Kafka config matching repro
    config.kafka = {
      'bootstrap.servers': ENV.fetch('KAFKA_BROKER_LIST', '127.0.0.1:9092'),
      'enable.auto.commit': ENV.fetch('KARAFKA_CONSUMER_AUTO_COMMIT_OFFSETS', 'true') == 'true',
      'session.timeout.ms': ENV.fetch('KARAFKA_CONSUMER_SESSION_TIMEOUT_2', '30').to_i * 1000,
      'socket.timeout.ms': ENV.fetch('KARAFKA_CONSUMER_SOCKET_TIMEOUT', '260').to_i * 1000,
      'max.poll.interval.ms': ENV.fetch('KARAFKA_CONSUMER_MAX_POLL_INTERVAL_2', '60').to_i * 1000,
      'heartbeat.interval.ms': ENV.fetch('KARAFKA_CONSUMER_HEARTBEAT_INTERVAL_2', '3').to_i * 1000,
      'fetch.message.max.bytes': ENV.fetch('KARAFKA_CONSUMER_MAX_BYTES_PER_PARTITION', '1048576').to_i
    }
  end

  Karafka.monitor.subscribe(
    Karafka::Instrumentation::LoggerListener.new(log_polling: false)
  )

  Karafka.producer.monitor.subscribe(
    WaterDrop::Instrumentation::LoggerListener.new(
      Karafka.logger,
      log_messages: false
    )
  )

  # Error monitoring from repro
  Karafka.monitor.subscribe 'error.occurred' do |event|
    error = event[:error]
    trace = (error.backtrace || []).join("\n")
    Karafka.logger.error("Error: #{error} of type: #{event[:type]} occurred.\n#{trace}")
  end

  routes.draw do
    active_job_topic :default do
      config(partitions: 5, 'retention.ms': 86_400_000)
    end

    topic :visits do
      config(partitions: 2)
      consumer VisitsConsumer
    end
  end
end

Karafka::Web.enable!

# Datadog metrics listener (from repro)
if ENV['ENABLE_DATADOG_METRICS'] == 'true'
  statsd = Datadog::Statsd.new(
    ENV.fetch('STATSD_HOST', '127.0.0.1'),
    ENV.fetch('STATSD_PORT', '8125').to_i
  )
  # Subscribe datadog listener here if needed
end
