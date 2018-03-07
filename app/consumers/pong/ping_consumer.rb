# frozen_string_literal: true

# Namespace for everything related to our small ping-pong game
module Pong
  # Catches the ping and uses PingResponder to respond on a pong topic
  class PingConsumer < ApplicationConsumer
    def consume
      # The initial ping needs to be triggered via the rake task
      respond_with(counter: params_batch.parsed.last['counter'] + 1)
    end
  end
end
