# frozen_string_literal: true

RSpec.describe ApplicationController do
  specify { expect(described_class).to be < Karafka::BaseController }
end
