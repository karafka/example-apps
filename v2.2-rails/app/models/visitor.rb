# frozen_string_literal: true

# Represents a single website visitor
class Visitor < ApplicationRecord
  has_many :visits
end
