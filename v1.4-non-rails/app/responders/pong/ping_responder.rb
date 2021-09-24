# frozen_string_literal: true

module Pong
  # Responder triggered from within the PingConsumer
  class PingResponder < ApplicationResponder
    topic :pong

    # @param data [Hash] any data that we want to send
    # @note Will be serialized to json
    def respond(data)
      respond_to :pong, data
    end
  end
end
