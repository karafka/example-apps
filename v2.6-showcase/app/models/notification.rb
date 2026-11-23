# frozen_string_literal: true

# A notification "sent" to the customer
class Notification < ApplicationRecord
  belongs_to :order
end
