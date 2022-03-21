class LoggingMiddleware
  def self.perform(params)
    start_time = Time.now
    Karafka.logger.info { "#{params[:consumer_name]} started, params: #{params}" }
    yield
    Karafka.logger.info { "#{params[:consumer_name]} completed, execution time: #{(Time.now - start_time)}" }
  end
end