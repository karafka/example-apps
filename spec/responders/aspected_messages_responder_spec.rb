# frozen_string_literal: true

RSpec.describe AspectedMessagesResponder do
  specify { expect(described_class).to be < ApplicationResponder }

  let(:responder) { described_class.new }

  describe '#respond' do
    let(:message) { rand.to_s }

    before do
      allow(responder)
        .to receive(:respond_to)
        .with(:receiver_message, message)
    end

    it { responder.respond(message) }
  end
end
