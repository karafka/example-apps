# frozen_string_literal: true

# Consumer that includes some demo callbacks to show you how to use them
class CallbackedConsumer < ApplicationConsumer

  def consume
    Karafka.logger.info "consumer processed message #{params.inspect}"
  rescue => error
    Karafka.logger.error  {"EventHandler::Error while processing event with data #{params} -- error #{error}"}
  end

end
