# frozen_string_literal: true

# "Sends" customer notifications
class NotificationsConsumer < ApplicationConsumer
  def consume
    messages.each do |message|
      notice = message.payload

      Notification.find_or_create_by!(order_id: notice['order_id'], kind: notice['kind'])
      Karafka.logger.info("Email #{notice["kind"]} sent for order #{notice["order_id"]}")
    end
  end
end
