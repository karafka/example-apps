# frozen_string_literal: true

# Fake card payment gateway
#
# Card tokens drive the outcome:
#   - `declined` - the card is declined every time (ends in the DLQ)
#   - `unavailable` - the gateway is down for the first few attempts, then charges the card
#   - anything else - the card is charged
module PaymentGateway
  # Permanent failure: retrying does not help
  class Declined < StandardError; end

  # Temporary failure: the gateway asks us to back off
  class Unavailable < StandardError; end

  # How many times an `unavailable` card fails before it goes through
  OUTAGE_ATTEMPTS = 1

  @outages = Hash.new(0)
  @mutex = Mutex.new

  class << self
    # @param order_id [Integer]
    # @param card [String] card token
    # @param amount_cents [Integer]
    # @return [String] payment id
    def charge(order_id:, card:, amount_cents:)
      case card
      when 'declined'
        raise Declined, "card declined for order #{order_id} (#{amount_cents})"
      when 'unavailable'
        raise Unavailable, 'gateway unavailable' if outage?(order_id)
      end

      "pay_#{order_id}"
    end

    private

    # @param order_id [Integer]
    # @return [Boolean] true while the simulated outage for this order lasts
    def outage?(order_id)
      @mutex.synchronize do
        @outages[order_id] += 1
        @outages[order_id] <= OUTAGE_ATTEMPTS
      end
    end
  end
end
