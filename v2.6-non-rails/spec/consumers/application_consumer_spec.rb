# frozen_string_literal: true

RSpec.describe ApplicationConsumer do
  specify { expect(described_class).to be < Karafka::BaseConsumer }
end
