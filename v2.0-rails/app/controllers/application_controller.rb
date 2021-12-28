# frozen_string_literal: true

# Main app controller
class ApplicationController < ActionController::Base
  before_action :assign_visitor_id
  before_action :track_visit

  private

  # Assigns a unique identifier to the user visiting the page, so we can track him
  def assign_visitor_id
    session[:visitor_id] ||= SecureRandom.uuid
  end

  # Async user tracking
  def track_visit
    VisitorsJob.perform_later(session[:visitor_id])

    Karafka.producer.produce_async(
      topic: 'visits',
      payload: {
        id: SecureRandom.uuid,
        visited_at: Time.zone.now,
        visitor_id: session[:visitor_id],
        page_path: request.path
      }.to_json
    )
  end
end
