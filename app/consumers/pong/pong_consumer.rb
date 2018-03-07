# frozen_string_literal: true

module Pong
  # Catches the pong and uses PongResponder to respond on a ping topic
  class PongConsumer < ApplicationConsumer
    def consume
      # Just a small delay so we won't overuse the CPU
      sleep rand
      respond_with('counter' => params_batch.parsed.to_a.last['counter'] + 1)
    end
  end
end
