# Responder for AspectedMessageController which can respond to receiver_message topic
class AspectedMessagesResponder < ApplicationResponder
  topic :receiver_message

  # Sending message to receiver_message topic
  # @param [String] message which controller will send
  def respond(message)
    respond_to :receiver_message, message
  end
end
