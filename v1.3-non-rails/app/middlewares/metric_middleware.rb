class MetricMiddleware
  def self.perform(params)
    yield
  end
end