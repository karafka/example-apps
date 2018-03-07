module Pong
  class PingResponder < ApplicationResponder
    topic :pong

    def respond(data)
      respond_to :pong, data
    end
  end
end
