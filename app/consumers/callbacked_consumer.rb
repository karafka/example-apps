# frozen_string_literal: true

# Consumer that includes some demo callbacks to show you how to use them
class CallbackedConsumer < ApplicationConsumer
  include Karafka::Consumers::Callbacks

  # This callback can be used to preprocess received messages
  # especially if they are going to be
  after_fetch do
    # Adds extra params key so we know it is (or not) wednesday
    params_batch.each do |params|
      params['wednesday'] = Date.today.wednesday?
    end
  end

  before_stop do
    mark_as_consumed params_batch.last
    Karafka.logger.info 'Bye bye :('
  end

  before_poll do
    Karafka.logger.info "Lets check if there is anything new for #{topic.name}"
  end

  after_poll do
    Karafka.logger.info 'Yay! We just checked for new messages!'
  end

  # Consumes given messages
  def consume
    params_batch.each do |params|
      Karafka.logger.info "Is it wednesday? #{params['wednesday']}"
    end
  end
end
