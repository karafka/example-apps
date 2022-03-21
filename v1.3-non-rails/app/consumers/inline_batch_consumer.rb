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
          .map { |param| param.payload['number'] }
          .inject(0) { |accu, val| accu + val }

    Karafka.logger.info "Sum of #{params_batch.count} elements equals to: #{sum}"

    # This is not needed as automatic offset management is on, but we add it just to illustrate
    # that the karafka-testing works with this case as well
    mark_as_consumed!(params_batch.last)
  end
end
