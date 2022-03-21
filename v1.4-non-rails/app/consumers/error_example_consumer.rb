# frozen_string_literal: true

# Consumer that is meant to raise an error for a while
class ErrorExampleConsumer < ApplicationConsumer
  def consume
    Karafka.logger.info "Received following message: #{params.payload['message']}"

    raise StandardError.new('Ups something went wrong') if params.payload['message'] == 'raise_error'
  end
end
