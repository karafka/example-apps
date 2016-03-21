require 'spec_helper'

RSpec.describe OtherMessagesController do
  specify { expect(described_class).to be < ApplicationController }

  describe '#perform' do
    it 'should do nothing' do
      expect(subject.perform).to eq false
    end
  end
end
