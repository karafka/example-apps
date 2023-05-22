# frozen_string_literal: true

# Consumer that is meant to handle xml data
class XmlMessagesConsumer < ApplicationConsumer
  # This method just logs parsed data with Karafka logger
  def consume
    messages.each do |message|
      Karafka.logger.info "Consumed following message: #{message.payload}"
    end
  end
end
