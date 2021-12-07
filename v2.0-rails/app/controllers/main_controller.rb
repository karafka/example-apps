class MainController < ApplicationController
  def show
    @recent_visits = Visit.recent
  end
end
