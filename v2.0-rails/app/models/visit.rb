# frozen_string_literal: true

# Represents a single page visit
class Visit < ApplicationRecord
  scope :recent, -> { joins(:visitor).order(visited_at: :desc).limit(20) }

  belongs_to :visitor

  # @note This is not used in the example app but is used to demonstrate how we can also spec out
  # messages production when models or anything else is publishing data
  def broadcast
    Karafka.producer.produce_async(
      topic: 'visits',
      payload: {
        id: id,
        visited_at: visited_at,
        visitor_id: visitor_id,
        page_path: page_path
      }.to_json
    )
  end
end
