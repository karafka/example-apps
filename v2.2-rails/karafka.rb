# frozen_string_literal: true

# Karafka app object
class KarafkaApp < Karafka::App
  setup do |config|
    config.kafka = { 'bootstrap.servers': '127.0.0.1:9092' }
    config.client_id = 'example_app'
    config.concurrency = 2
    config.max_wait_time = 500 # 0.5 second
    # Recreate consumers with each batch. This will allow Rails code reload to work in the
    # development mode. Otherwise Karafka process would not be aware of code changes
    config.consumer_persistence = !Rails.env.development?
  end

  # Comment out this part if you are not using instrumentation and/or you are not
  # interested in logging events for certain environments. Since instrumentation
  # notifications add extra boilerplate, if you want to achieve max performance,
  # listen to only what you really need for given environment.
  Karafka.monitor.subscribe(Karafka::Instrumentation::LoggerListener.new)
  # Karafka.monitor.subscribe(Karafka::Instrumentation::ProctitleListener.new)
  Karafka.producer.monitor.subscribe(
    WaterDrop::Instrumentation::LoggerListener.new(
      Karafka.logger,
      # If you set this to true, logs will contain each message details
      # Please note, that this can be extensive
      log_messages: false
    )
  )

  routes.draw do
    # This needs to match queues defined in your ActiveJobs
    active_job_topic :default do
      # Expire jobs after 1 day
      config(partitions: 5, 'retention.ms': 86_400_000)
    end

    topic :visits do
      config(partitions: 2)
      consumer VisitsConsumer
    end
  end
end

Karafka::Web.enable!

# You can tag your processes with any info you want and it is going to be visible via the Web UI
git_hash = `git rev-parse --short HEAD`.strip
Karafka::Process.tags.add(:commit, "##{git_hash}")
