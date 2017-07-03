# frozen_string_literal: true

RSpec.describe OtherMessagesController do
  specify { expect(described_class).to be < ApplicationController }

  subject(:controller) { described_class.new }

  describe '#perform' do
    it 'does nothing' do
      expect(controller.perform).to eq false
    end
  end
end
