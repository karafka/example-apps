# frozen_string_literal: true

# Namespace for everything related to our small ping-pong game
module Pong
  # Catches the ping and uses PingResponder to respond on a pong topic
  class PingConsumer < ApplicationConsumer
    # We increase the pings counter and respond
    def consume
      counter = params.payload['counter'] + 1
      # The initial ping needs to be triggered via the rake task
      raise StandardError if counter == 5
      respond_with(counter: counter)
    end
  end
end
