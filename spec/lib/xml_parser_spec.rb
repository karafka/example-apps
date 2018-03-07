# frozen_string_literal: true

RSpec.describe XmlParser do
  describe '.parse' do
    context 'when message has correct xml format' do
      let(:message) { '<message><new>home</new></message>' }

      it { expect(described_class.parse(message)).to eq('message' => { 'new' => 'home' }) }
    end

    context 'when message has wrong xml format' do
      let(:message) { '<message>' }

      it { expect { described_class.parse(message) }.to raise_error(REXML::ParseException) }
    end
  end
end
