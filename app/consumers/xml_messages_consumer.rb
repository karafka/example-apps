# frozen_string_literal: true

# Consumer that is ment to handle xml data
# @note It will process single messages one after another as the batch_consuming
#   is set to false
class XmlMessagesConsumer < ApplicationConsumer
  # This method just logs parsed data with Karafka logger
  def consume
    Karafka.logger.info "Consumed following message: #{params}"
  end
end
