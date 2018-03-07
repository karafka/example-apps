# frozen_string_literal: true

module Pong
  # Respnder triggered from within the pong consumer
  class PongResponder < ApplicationResponder
    topic :ping

    def respond(data)
      respond_to :ping, data
    end
  end
end
