# frozen_string_literal: true

RSpec.describe ApplicationWorker do
  specify { expect(described_class).to be < Karafka::BaseWorker }
end
