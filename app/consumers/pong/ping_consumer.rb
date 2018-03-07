# frozen_string_literal: true

# Namespace for everything related to our small ping-pong game
module Pong
  # Catches the ping and uses PingResponder to respond on a pong topic
  class PingConsumer < ApplicationConsumer
    # We increase the pings counter and respond
    def consume
      counter = params_batch.parsed.last['counter'] + 1
      # The initial ping needs to be triggered via the rake task
      respond_with(counter: counter)
    end
  end
end
