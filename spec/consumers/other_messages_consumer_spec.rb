# frozen_string_literal: true

RSpec.describe OtherMessagesConsumer do
  specify { expect(described_class).to be < ApplicationConsumer }

  subject(:consumer) { described_class.new }

  describe '#consume' do
    it 'does nothing' do
      expect(consumer.consume).to eq false
    end
  end
end
