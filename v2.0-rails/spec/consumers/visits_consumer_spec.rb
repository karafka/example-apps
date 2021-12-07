# frozen_string_literal: true

RSpec.describe VisitsConsumer do
  subject(:consumer) { karafka.consumer_for(:visits) }

  let(:visitor_id) { SecureRandom.uuid }

  before do
    # Publish two visits of one user
    karafka.publish({ visited_at: Time.zone.now, visitor_id: visitor_id, page_path: '/' }.to_json)
    karafka.publish({ visited_at: Time.zone.now, visitor_id: visitor_id, page_path: '/' }.to_json)
  end

  it 'expects to save the visits' do
    expect { consumer.consume }.to change(Visit, :count).by(2)
  end
end
