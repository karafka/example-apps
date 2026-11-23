# frozen_string_literal: true

# Builds per-customer order totals from the `orders` topic
#
# Orders are keyed by customer, so all orders of a customer land in one partition. Set
# `REPLAY_FROM` (any time `Time.parse` accepts) to rebuild the totals: on the first batch each
# partition drops its totals and seeks back to that time.
class OrderStatsConsumer < ApplicationConsumer
  def consume
    return if replay

    messages.each do |message|
      order = message.payload
      stat = CustomerStat.find_or_initialize_by(customer_id: order['customer_id'])
      stat.partition = partition
      stat.orders_count += 1
      stat.total_cents += order['amount_cents']
      stat.save!
    end
  end

  private

  # @return [Boolean] true when we seeked back and this batch must be skipped
  def replay
    return false if @replayed || ENV['REPLAY_FROM'].to_s.empty?

    @replayed = true
    CustomerStat.where(partition: partition).delete_all
    seek(Time.parse(ENV.fetch('REPLAY_FROM')))

    true
  end
end
