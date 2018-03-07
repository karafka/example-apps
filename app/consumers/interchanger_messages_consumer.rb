# frozen_string_literal: true

# This consumer define interchanger which load and parse params
# with Base64 interchanger
class InterchangerMessagesConsumer < ApplicationConsumer
  # Here we set any logic what should be done in sidekiq once consumer receives
  # message to 'interchanger_messages' topic.
  # In this example it logs received params in 'log/interchanger_consumer_params' file
  def consume
    sleep 10
    LoggerService.new.write_to_file(
      self,
      File.join(Karafka::App.root, 'log', 'interchanger_consumer_params.log')
    )
  end
end
