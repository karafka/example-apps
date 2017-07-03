# frozen_string_literal: true

# This controller define interchanger which load and parse params
# with Base64 interchanger
class InterchangerMessagesController < ApplicationController
  # Here we set any logic what should be done in sidekiq once controller receives
  # message to 'interchanger_messages' topic.
  # In this example it logs received params in 'log/interchanger_controller_params' file
  def perform
    sleep 10
    LoggerService.new.write_to_file(
      self,
      File.join(Karafka::App.root, 'log', 'interchanger_controller_params.log')
    )
  end
end
