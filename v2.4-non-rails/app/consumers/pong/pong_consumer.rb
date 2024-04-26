# frozen_string_literal: true

module Pong
  # Catches the pong and uses PongResponder to respond on a ping topic
  class PongConsumer < ApplicationConsumer
    # Increase ball hits and respond
    def consume
      # Just a small delay so we won't overuse the CPU
      sleep rand
      hits = messages.last.payload['hits'] + 1
      Karafka.logger.info "Pong consumer with hits: #{hits}"
      producer.produce_async(topic: 'ping', payload: { hits: hits }.to_json)
    end
  end
end
