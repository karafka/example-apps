require 'spec_helper'

RSpec.describe OtherMessagesController do
  describe '.worker' do
    it { expect(described_class.worker).to eq DifferentWorker }
  end

  describe '#perform' do
    it 'should do nothing' do
      expect(subject.perform).to eq false
    end
  end
end
