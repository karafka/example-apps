# frozen_string_literal: true

module Pong
  # Respnder triggered from within the pong consumer
  class PongResponder < ApplicationResponder
    topic :ping

    # @param data [Hash] any data that we want to send
    # @note Will be serialized to json
    def respond(data)
      respond_to :ping, data
    end
  end
end
