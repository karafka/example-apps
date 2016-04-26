require 'spec_helper'

RSpec.describe ApplicationWorker do
  specify { expect(described_class).to be < Karafka::BaseWorker }
end
