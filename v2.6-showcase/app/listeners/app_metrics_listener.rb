# frozen_string_literal: true

# Business-level instrumentation on top of the Karafka notifications bus
class AppMetricsListener
  # @param event [Karafka::Core::Monitoring::Event]
  def on_consumer_consumed(event)
    consumer = event[:caller]

    Karafka.logger.info(
      "[metrics] #{consumer.topic.consumer_group.name}/#{consumer.topic.name}" \
      "-#{consumer.partition} consumed #{consumer.messages.size} message(s) " \
      "in #{event[:time].round(2)}ms"
    )
  end

  # @param event [Karafka::Core::Monitoring::Event]
  def on_dead_letter_queue_dispatched(event)
    message = event[:message]

    Karafka.logger.warn(
      "[metrics] #{message.topic}/#{message.partition}@#{message.offset} moved to the DLQ"
    )
  end

  # @param event [Karafka::Core::Monitoring::Event]
  def on_error_occurred(event)
    Karafka.logger.error("[metrics] #{event[:type]}: #{event[:error].class}")
  end
end
