# frozen_string_literal: true

# Dummy worker that just proves that we can use custom workers with Karafka consumers
class DifferentWorker < ApplicationWorker
  # @param _params Any params that we want to have
  # @return [Boolean] false always
  def perform_async(*_params)
    false
  end
end
