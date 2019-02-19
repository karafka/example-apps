# frozen_string_literal: true

RSpec.describe XmlDeserializer do
  subject(:deserializer) { described_class.new }

  describe '#call' do
    context 'when message has correct xml format' do
      let(:message) { '<message><new>home</new></message>' }

      it { expect(deserializer.call(message)).to eq('message' => { 'new' => 'home' }) }
    end

    context 'when message has wrong xml format' do
      let(:message) { '<message>' }

      it { expect { deserializer.call(message) }.to raise_error(REXML::ParseException) }
    end
  end
end
