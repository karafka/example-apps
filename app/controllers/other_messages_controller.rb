require 'karafka'

# This controller has a custom worker set to it (a dummy one that will do nothing)
class OtherMessagesController < Karafka::BaseController
  self.worker = DifferentWorker

  # This is a dummy method that won't perform anything
  def perform
    # Do nothing
    false
  end
end
