# frozen_string_literal: true

# This controller has a custom worker set to it (a dummy one that will do nothing)
class OtherMessagesController < ApplicationController
  # This is a dummy method that won't perform anything
  def perform
    # Do nothing
    false
  end
end
