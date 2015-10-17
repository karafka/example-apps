require 'spec_helper'

RSpec.describe DifferentWorker do
  describe '#perform' do
    it 'should do nothing' do
      expect(subject.perform_async).to eq false
    end
  end
end
