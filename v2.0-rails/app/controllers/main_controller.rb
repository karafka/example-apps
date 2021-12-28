# frozen_string_literal: true

class MainController < ApplicationController
  def show
    @recent_visits = Visit.recent
  end
end
