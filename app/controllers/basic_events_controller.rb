require 'karafka'

# This controller does not have before_enqueue callbacks,
# so it will receive all messages which are sent to karafka_topic_basic topic
class BasicEventsController < Karafka::BaseController
  self.group = :karafka_topic_basic
  self.topic = :karafka_topic_basic

  # Here we set any logic what should be done in sidekiq once controller receives
  # message to 'karafka_topic_basic' topic.
  # In this example it logs received params in 'log/basic_controller_params' file
  def perform
    sleep 10
    LoggerService.new.write_to_file(self, "#{Karafka::App.root}/log/basic_controller_params.log")
  end
end
