class ApplicationController < ActionController::Base
  before_action :assign_visitor_id
  before_action :track_visit

  private

  def assign_visitor_id
    session[:visitor_id] ||= SecureRandom.uuid
  end

  def track_visit
    Karafka.producer.produce_async(
      topic: 'visits',
      payload: {
        visited_at: Time.zone.now,
        visitor_id: session[:visitor_id],
        page_path: request.path
      }.to_json
    )
  end
end
