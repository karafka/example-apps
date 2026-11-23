# frozen_string_literal: true

# Charges orders and publishes the payment results
#
# Offsets are marked manually, only after the gateway confirms the charge. A gateway outage
# pauses the partition (backpressure, no retry counted). A declined card raises, is retried
# and after `max_retries` is moved to the `payments_dlq` topic.
class PaymentsConsumer < ApplicationConsumer
  # How long to back off when the gateway is unavailable
  BACKOFF_MS = 2_000

  def consume
    messages.each do |message|
      order = message.payload

      Karafka.logger.info("Charging order #{order["id"]} (attempt #{attempt})") if retrying?

      begin
        payment_id = PaymentGateway.charge(
          order_id: order['id'],
          card: order['card'],
          amount_cents: order['amount_cents']
        )
      rescue PaymentGateway::Unavailable
        pause(message.offset, BACKOFF_MS)
        break
      end

      Order.where(id: order['id']).update_all(status: 'paid')

      produce_sync(
        topic: 'payments',
        key: order['id'].to_s,
        payload: { order_id: order['id'], payment_id: payment_id, sku: order['sku'],
                   quantity: order['quantity'] }.to_json
      )

      mark_as_consumed(message)
    end
  end
end
