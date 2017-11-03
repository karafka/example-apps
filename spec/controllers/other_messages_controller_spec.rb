# frozen_string_literal: true

RSpec.describe OtherMessagesController do
  specify { expect(described_class).to be < ApplicationController }

  subject(:controller) { described_class.new }

  describe '#consume' do
    it 'does nothing' do
      expect(controller.consume).to eq false
    end
  end
end
