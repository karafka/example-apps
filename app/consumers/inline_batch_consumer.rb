# frozen_string_literal: true

# This consumer receives a batch of messages at once (not a single message)
# You can use it to process multiple messages at  the same time, for example
# for batch inserting ito database, etc
# The batch is accessible using the #params_batch method
class InlineBatchConsumer < ApplicationConsumer
  # Performs business logic with messages batch
  def consume
    # You can access the params_batch as an array and just work with it
    sum = params_batch
          .map { |param| param.fetch('number') }
          .inject(0) { |accu, val| accu + val }
    Karafka.logger.info "Sum of #{params_batch.count} elements equals to: #{sum}"
  end
end
