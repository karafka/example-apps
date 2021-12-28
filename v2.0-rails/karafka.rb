# frozen_string_literal: true

require ::File.expand_path('../config/environment', __FILE__)

class KarafkaApp < Karafka::App
  setup do |config|
    config.kafka = { 'bootstrap.servers' => '127.0.0.1:9092' }
    config.client_id = 'example_app'
  end

  # Comment out this part if you are not using instrumentation and/or you are not
  # interested in logging events for certain environments. Since instrumentation
  # notifications add extra boilerplate, if you want to achieve max performance,
  # listen to only what you really need for given environment.
  Karafka.monitor.subscribe(Karafka::Instrumentation::StdoutListener.new)
  # Karafka.monitor.subscribe(Karafka::Instrumentation::ProctitleListener.new)

  routes.draw do
    # This needs to match queues defined in your ActiveJobs
    active_job_topic :default

    topic :visits do
      consumer VisitsConsumer
    end
  end
end
