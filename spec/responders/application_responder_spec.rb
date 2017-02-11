require 'spec_helper'

RSpec.describe ApplicationResponder do
  specify { expect(described_class).to be < Karafka::BaseResponder }
end
