# frozen_string_literal: true

# This consumer has a custom worker set to it (a dummy one that will do nothing)
class OtherMessagesConsumer < ApplicationConsumer
  # This is a dummy method that won't perform anything
  def consume
    # Do nothing
    false
  end
end
