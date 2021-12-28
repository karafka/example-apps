# frozen_string_literal: true

class Visit < ApplicationRecord
  scope :recent, -> { joins(:visitor).order(visited_at: :desc).limit(20) }

  belongs_to :visitor
end
