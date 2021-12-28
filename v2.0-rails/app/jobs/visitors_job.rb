# frozen_string_literal: true

# This is an example job that runs using Karafka. It acts like any other Rails job
class VisitorsJob < ApplicationJob
  # @param visitor_id [String] id of the visitor that we want to create (if not present)
  def perform(visitor_id)
    # Creates a visitor instance if not present
    Visitor.insert_all([id: visitor_id])
  end
end
