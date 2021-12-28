# frozen_string_literal: true

# Main page display
class MainController < ApplicationController
  # Displays recent visits
  def show
    @recent_visits = Visit.recent
  end
end
