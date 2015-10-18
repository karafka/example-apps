# Dummy worker that just proves that we can use custom workers with Karafka controllers
class DifferentWorker
  # @param _params Any params that we want to have
  # @return [Boolean] false always
  def perform_async(*_params)
    false
  end
end
