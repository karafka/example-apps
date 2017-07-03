# frozen_string_literal: true

RSpec.describe DifferentWorker do
  subject(:worker) { described_class.new }

  describe '#perform' do
    it 'does nothing' do
      expect(worker.perform_async).to eq false
    end
  end
end
