# frozen_string_literal: true

# Application consumer from which all Karafka consumers should inherit
# You can rename it if it would conflict with your current code base (in case you're integrating
# Karafka with other frameworks)

class ApplicationConsumer < Karafka::BaseConsumer

  MIDDLEWARES = [LoggingMiddleware, MetricMiddleware].freeze

  def call
    params[:consumer_name] = self.class.name
    params[:request_uuid] = set_request_uuid
    using_middlewares MIDDLEWARES, params, 0 do
      super
    end
  end

  private

  def using_middlewares(middlewares, params, cur_index, &block)
    return block.call if cur_index >= middlewares.length

    middleware = middlewares[cur_index]
    middleware.perform params do
      using_middlewares(middlewares, params, cur_index + 1, &block)
    end
  end

  def set_request_uuid
    SecureRandom.uuid
  end

end
