# frozen_string_literal: true

RSpec.describe ApplicationResponder do
  specify { expect(described_class).to be < Karafka::BaseResponder }
end
