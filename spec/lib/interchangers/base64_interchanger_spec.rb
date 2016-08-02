require 'spec_helper'

RSpec.describe Base64Interchanger do
  let(:params) { double }
  subject(:interchanger) { described_class }

  describe '.load' do
    before do
      expect(Marshal)
        .to receive(:dump)
        .with(params)
        .and_return(params)

      expect(Base64)
        .to receive(:encode64)
        .with(params)
    end

    it { interchanger.load(params) }
  end

  describe '.parse' do
    before do
      expect(Base64)
        .to receive(:decode64)
        .with(params)
        .and_return(params)

      expect(Marshal)
        .to receive(:load)
        .with(params)
    end

    it { interchanger.parse(params) }
  end
end
