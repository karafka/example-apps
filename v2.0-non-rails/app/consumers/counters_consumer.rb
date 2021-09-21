# frozen_string_literal: true

# This consumer receives a batch of messages at once
# You can use it to process multiple messages at  the same time, for example
# for batch inserting ito database, etc
# The batch is accessible using the #messages method
class CountersConsumer < ApplicationConsumer
  # Performs business logic with messages batch
  def consume
    # You can access the messages as an array and just work with it
    sum = messages
          .map { |message| message.payload['number'] }
          .inject(0) { |accu, val| accu + val }

    Karafka.logger.info "Sum of #{messages.count} elements equals to: #{sum}"
  end
end
