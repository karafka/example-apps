# frozen_string_literal: true

# This consumer does not have after_received callbacks,
# so it will receive all messages which are sent to basic_messages topic
class BasicMessagesConsumer < ApplicationConsumer
  # Here we set any logic what should be done in sidekiq once consumer receives
  # message to 'basic_messages' topic.
  # In this example it logs received params in 'log/basic_consumer_params' file
  def consume
    sleep 10
    LoggerService.new.write_to_file(
      self,
      File.join(Karafka::App.root, 'log', 'basic_consumer_params.log')
    )
  end
end
