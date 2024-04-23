# frozen_string_literal: true

# Namespace for everything related to our small ping-pong game
module Pong
  # Catches the ping and uses producer to respond on a pong topic
  class PingConsumer < ApplicationConsumer
    # We increase the ball hits and respond
    def consume
      hits = messages.last.payload['hits'] + 1
      # The initial ping needs to be triggered via the rake task
      Karafka.logger.info "Ping consumer with hits: #{hits}"
      producer.produce_async(topic: 'pong', payload: { hits: hits }.to_json)
    end
  end
end
