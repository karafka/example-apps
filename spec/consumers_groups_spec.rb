# frozen_string_literal: true

RSpec.describe Karafka::App.consumer_groups do
  describe 'batched group' do
    let(:group) do
      Karafka::App.consumer_groups.find do |cg|
        cg.name == 'batched_group'
      end
    end

    describe 'xml_data topic' do
      let(:topic) { group.topics.find { |ts| ts.name == 'xml_data' } }

      it { expect(topic.parser).to eq XmlParser }
    end
  end
end
