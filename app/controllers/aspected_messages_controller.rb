require 'karafka'

# Controller which receive messages based on aspect implementation
class AspectedMessagesController < Karafka::BaseController
  # Here we set method which should be executed before perform.
  # You can write as many before_enqueue callbacks as it is needed.
  # If one of before_enqueue callbacks returns false -
  # perform method will not be enqueued to sidekiq
  before_enqueue :check_params

  # Here we set any logic what should be done in sidekiq once controller receives
  # message to 'aspected_messages' topic.
  # In this example it logs received params in 'log/aspect_controller_params.log' file
  def perform
    sleep 10
    LoggerService.new.write_to_file(
      self,
      "#{Karafka::App.root}/log/aspect_controller_params.log",
      params
    )
  end

  # Here should be implemented logic once sidekiq fails
  def after_failure
    LoggerService.new.clear_file("#{Karafka::App.root}/log/aspect_controller_params.log")
  end

  private

  # Send to sidekiq only those events, which message will be more than 30
  def check_params
    params['message'].to_i > 30
  end
end
