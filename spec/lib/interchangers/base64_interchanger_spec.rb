require 'spec_helper'

RSpec.describe Base64Interchanger do
  subject { described_class }
  let(:params) { double }

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

    it { subject.load(params) }
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

    it { subject.parse(params) }
  end
end
