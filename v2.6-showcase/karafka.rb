# frozen_string_literal: true

# Karafka app object
class KarafkaApp < Karafka::App
  setup do |config|
    config.kafka = { 'bootstrap.servers': ENV.fetch('KAFKA_BOOTSTRAP_SERVERS', '127.0.0.1:9092') }
    config.client_id = 'showcase_app'
    config.concurrency = 2
    config.max_wait_time = 500
    # Each `karafka swarm` node is a forked process with its own consumers
    config.swarm.nodes = 2
  end

  Karafka.monitor.subscribe(Karafka::Instrumentation::LoggerListener.new(log_polling: false))
  Karafka.monitor.subscribe(AppMetricsListener.new)

  Karafka.producer.monitor.subscribe(
    WaterDrop::Instrumentation::LoggerListener.new(Karafka.logger, log_messages: false)
  )

  declaratives.draw do
    topic :orders do
      partitions 3
    end

    topic :payments do
      partitions 3
    end

    topic :payments_dlq do
      partitions 1
      # Keep failed payments for a week so they can be inspected and replayed
      config('retention.ms': 604_800_000)
    end

    topic :inventory do
      partitions 3
    end

    topic :notifications do
      partitions 3
    end

    topic :products do
      partitions 1
      # Latest state per SKU only
      config('cleanup.policy': 'compact')
    end
  end

  routes.draw do
    consumer_group :payments do
      topic :orders do
        consumer PaymentsConsumer
        manual_offset_management true
        # Two retries with a pause, then the order goes to the DLQ and processing moves on.
        # With manual offset management the DLQ does not commit the dispatched message unless
        # asked to: without it a restart would send the same order to the DLQ again.
        dead_letter_queue(topic: 'payments_dlq', max_retries: 2, mark_after_dispatch: true)
      end
    end

    consumer_group :analytics do
      # Same topic as the payments group, with its own offsets and lag
      topic :orders do
        consumer OrderStatsConsumer
      end
    end

    consumer_group :inventory do
      topic :payments do
        consumer InventoryConsumer
      end
    end

    consumer_group :notifications do
      topic :notifications do
        consumer NotificationsConsumer
      end
    end

    consumer_group :catalog do
      topic :products do
        consumer ProductsCacheConsumer
        # `#eofed` needs librdkafka to report the partition end
        kafka('enable.partition.eof': true, inherit: true)
        eofed true
      end
    end
  end

  # Pro layer: drawn only with a license, so this app also runs without one
  if Karafka.pro?
    routes.draw do
      # Virtual partitions, long-running jobs, delayed topics and other Pro routes go here
    end
  end
end

# Karafka closes only its own producer
Karafka.monitor.subscribe('app.stopped') { TransactionalProducer.close }

Karafka::Web.enable!
