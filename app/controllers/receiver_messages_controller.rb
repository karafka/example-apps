# frozen_string_literal: true

# Controller which receive messages based responder message
class ReceiverMessagesController < ApplicationController
  # Here we set any logic what should be done in sidekiq once controller receives
  # message to 'receiver_message' topic.
  # In this example it logs received params in 'log/receiver_controller' file
  def consume
    LoggerService.new.write_to_file(
      self,
      File.join(Karafka::App.root, 'log', 'receiver_controller.log')
    )
  end
end
