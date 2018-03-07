# frozen_string_literal: true

# Responder for AspectedMessageConsumer which can respond to receiver_message topic
class AspectedMessagesResponder < ApplicationResponder
  topic :receiver_message

  # Sending message to receiver_message topic
  # @param [String] message which consumer will send
  def respond(message)
    respond_to :receiver_message, message
  end
end
