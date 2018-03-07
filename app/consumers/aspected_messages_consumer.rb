# frozen_string_literal: true

# Consumer which receive messages based on aspect implementation
class AspectedMessagesConsumer < ApplicationConsumer
  # Here we set method which should be executed before perform.
  # You can write as many after_received callbacks as it is needed.
  # If one of after_fetched callbacks returns false -
  # perform method will not be run
  after_fetch :check_params

  # This consumer is in inline_mode so it'll be run immediately, without sidekiq
  # In this example it logs received params in 'log/aspect_consumer_params.log' file.
  # For this consumer exists responder, so we can use respond_with method, which will send
  # message to topic defined in responder
  def consume
    LoggerService.new.write_to_file(self, log_file)

    respond_with 'Get my message'
  end

  # Here should be implemented logic once sidekiq fails
  def after_failure
    LoggerService.new.clear_file(log_file)
  end

  private

  # Send to sidekiq only those events, which message will be more than 30
  def check_params
    params['message'].to_i > 30
  end

  # @return [String] log file path
  def log_file
    File.join(Karafka::App.root, 'log', 'aspect_consumer_params.log')
  end
end
