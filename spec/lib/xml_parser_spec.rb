# frozen_string_literal: true

RSpec.describe XmlParser do
  describe '.parse' do
    context 'message have correct xml format' do
      let(:message) { '<message><new>home</new></message>' }

      it { expect(described_class.parse(message)).to eq('message' => { 'new' => 'home' }) }
    end

    context 'message have wrong xml format' do
      let(:message) { '<message>' }

      it { expect { described_class.parse(message) }.to raise_error XmlParser::ParserError }
    end
  end
end
