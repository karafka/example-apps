# frozen_string_literal: true

RSpec.describe VisitsConsumer do
  subject(:consumer) { karafka.consumer_for(:visits) }

  let(:visitor_id) { SecureRandom.uuid }
  let(:visits) do
    Array.new(2) do
      {
        id: SecureRandom.uuid,
        visited_at: Time.zone.now,
        visitor_id: visitor_id,
        page_path: '/'
      }
    end
  end

  # Publish two visits of one user
  before { visits.each { |visit| karafka.produce(visit.to_json) } }

  it 'expects to save the visits' do
    expect { consumer.consume }.to change(Visit, :count).by(2)
  end
end
