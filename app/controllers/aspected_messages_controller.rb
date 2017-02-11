# Controller which receive messages based on aspect implementation
class AspectedMessagesController < ApplicationController
  # Here we set method which should be executed before perform.
  # You can write as many before_enqueue callbacks as it is needed.
  # If one of before_enqueue callbacks returns false -
  # perform method will not be run
  before_enqueue :check_params

  # This controller is in inline_mode so it'll be run immediately, without sidekiq
  # In this example it logs received params in 'log/aspect_controller_params.log' file.
  # For this controller exists responder, so we can use respond_with method, which will send
  # message to topic defined in responder
  def perform
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
    File.join(Karafka::App.root, 'log', 'aspect_controller_params.log')
  end
end
