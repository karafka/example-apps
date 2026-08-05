# frozen_string_literal: true

RSpec.describe XmlDeserializer do
  subject(:deserializer) { described_class.new }

  describe '#call' do
    let(:params) do
      Karafka::Messages::Message.new(
        message,
        Karafka::Messages::Metadata.new(
          deserializers: OpenStruct.new(payload: deserializer)
        )
      )
    end

    context 'when message has correct xml format' do
      let(:message) { '<message><new>home</new></message>' }

      it { expect(params.payload).to eq('message' => { 'new' => 'home' }) }
    end

    context 'when message has wrong xml format' do
      let(:message) { '<message>' }

      it { expect { params.payload }.to raise_error(REXML::ParseException) }
    end
  end
end
