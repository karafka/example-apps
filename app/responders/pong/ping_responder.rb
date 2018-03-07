# frozen_string_literal: true

module Pong
  # Responder triggered from within the PingConsumer
  class PingResponder < ApplicationResponder
    topic :pong

    def respond(data)
      respond_to :pong, data
    end
  end
end
