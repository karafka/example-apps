# frozen_string_literal: true

RSpec.describe Visit do
  subject(:visit) do
    described_class.create!(
      id: SecureRandom.uuid,
      visitor_id: visitor.id,
      visited_at: Time.zone.now,
      page_path: rand.to_s
    )
  end

  let(:visitor) { Visitor.create!(id: SecureRandom.uuid) }

  describe '#broadcast' do
    before { visit.broadcast }

    let(:produced_message) { karafka.produced_messages.last }
    let(:produced_json) { JSON.parse(produced_message[:payload]) }

    it { expect(karafka.produced_messages.size).to eq(1) }

    it { expect(produced_message[:topic]).to eq('visits') }
    it { expect(produced_json['id']).to eq(visit.id) }
    it { expect(produced_json['page_path']).to eq(visit.page_path) }
  end
end
