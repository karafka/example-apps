# frozen_string_literal: true

# Accepts orders and publishes them to Kafka
class OrdersController < ApplicationController
  skip_forgery_protection

  def index
    render json: Order.order(:id).as_json(include: { notifications: { only: :kind } })
  end

  def show
    render json: Order.find(params[:id]).as_json(include: { notifications: { only: :kind } })
  end

  def create
    product = Product.find_by!(sku: params.require(:sku))
    quantity = params.fetch(:quantity, 1).to_i

    order = Order.create!(
      customer_id: params.require(:customer_id),
      sku: product.sku,
      quantity: quantity,
      amount_cents: product.price_cents * quantity,
      card: params.fetch(:card, 'valid')
    )

    # Keyed by customer: one customer's orders keep their order within a partition
    Karafka.producer.produce_sync(
      topic: 'orders',
      key: order.customer_id,
      payload: order.event.to_json
    )

    render json: order, status: :created
  end
end
