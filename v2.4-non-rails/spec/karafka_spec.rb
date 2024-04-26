# frozen_string_literal: true

RSpec.describe Karafka do
  describe 'batched group' do
    let(:group) do
      described_class::App.consumer_groups.find do |cg|
        cg.name == 'batched_group'
      end
    end

    describe 'xml_data topic' do
      let(:topic) { group.topics.find('xml_data') }

      it { expect(topic.deserializers.payload).to be_a XmlDeserializer }
    end
  end
end
