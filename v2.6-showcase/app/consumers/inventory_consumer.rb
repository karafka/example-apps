# frozen_string_literal: true

# Reserves stock for paid orders
#
# The `inventory` event and the customer notification are published in one Kafka transaction:
# both are visible to consumers, or none is.
class InventoryConsumer < ApplicationConsumer
  def consume
    messages.each do |message|
      payment = message.payload

      reserve(payment)

      producer = TransactionalProducer.instance

      producer.transaction do
        producer.produce_async(
          topic: 'inventory',
          key: payment['sku'],
          payload: { sku: payment['sku'], reserved: payment['quantity'],
                     order_id: payment['order_id'] }.to_json
        )

        producer.produce_async(
          topic: 'notifications',
          key: payment['order_id'].to_s,
          payload: { order_id: payment['order_id'], kind: 'order_confirmed' }.to_json
        )
      end
    end
  end

  private

  # @param payment [Hash] payment event
  def reserve(payment)
    order = Order.find(payment['order_id'])
    return if order.reserved

    Order.transaction do
      Product.where(sku: payment['sku']).update_all(['stock = stock - ?', payment['quantity']])
      order.update!(reserved: true)
    end
  end
end
