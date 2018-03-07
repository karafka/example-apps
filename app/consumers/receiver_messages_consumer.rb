# frozen_string_literal: true

# Consumer which receive messages based responder message
class ReceiverMessagesConsumer < ApplicationConsumer
  # Here we set any logic what should be done in sidekiq once consumer receives
  # message to 'receiver_message' topic.
  # In this example it logs received params in 'log/receiver_consumer' file
  def consume
    LoggerService.new.write_to_file(
      self,
      File.join(Karafka::App.root, 'log', 'receiver_consumer.log')
    )
  end
end
