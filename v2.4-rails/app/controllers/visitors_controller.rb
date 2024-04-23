# frozen_string_literal: true

# Visitors display controller
class VisitorsController < ApplicationController
  # Lists most recent visitors
  def index
    @visitors = Visitor.order(created_at: :desc).limit(20)
  end

  # Shows visitor details
  def show
    @visitor = Visitor.find(params[:id])
    @visits = @visitor.visits.order(visited_at: :desc).first(20)
  end
end
