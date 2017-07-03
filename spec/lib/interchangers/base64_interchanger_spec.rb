# frozen_string_literal: true

RSpec.describe Base64Interchanger do
  subject(:interchanger) { described_class }

  let(:params) { double }

  describe '.load' do
    before do
      allow(Marshal)
        .to receive(:dump)
        .with(params)
        .and_return(params)

      allow(Base64)
        .to receive(:encode64)
        .with(params)
    end

    it { interchanger.load(params) }
  end

  describe '.parse' do
    before do
      allow(Base64)
        .to receive(:decode64)
        .with(params)
        .and_return(params)

      allow(Marshal)
        .to receive(:load)
        .with(params)
    end

    it { interchanger.parse(params) }
  end
end
