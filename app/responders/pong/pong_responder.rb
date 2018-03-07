module Pong
  class PongResponder < ApplicationResponder
    topic :ping

    def respond(data)
      respond_to :ping, data
    end
  end
end
