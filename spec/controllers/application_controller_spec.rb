require 'spec_helper'

RSpec.describe ApplicationController do
  specify { expect(described_class).to be < Karafka::BaseController }
end
