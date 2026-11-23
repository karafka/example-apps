# frozen_string_literal: true

# Customer order that flows through payments, inventory and notifications
class Order < ApplicationRecord
  has_many :notifications, dependent: :destroy

  # @return [Hash] event published to the `orders` topic
  def event
    as_json(only: %i[id customer_id sku quantity amount_cents card])
  end
end
