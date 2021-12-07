class Visit < ApplicationRecord
  scope :recent, -> { order(visited_at: :desc).limit(20) }
end
