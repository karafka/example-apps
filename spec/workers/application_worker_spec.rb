require 'spec_helper'

RSpec.describe DifferentWorker do
  specify { expect(described_class).to be < Karafka::BaseWorker }
end
