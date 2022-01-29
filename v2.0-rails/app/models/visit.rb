# frozen_string_literal: true

# Represents a single page visit
class Visit < ApplicationRecord
  scope :recent, -> { joins(:visitor).order(visited_at: :desc).limit(20) }

  belongs_to :visitor
end
