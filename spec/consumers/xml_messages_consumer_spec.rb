# frozen_string_literal: true

RSpec.describe XmlMessagesConsumer do
  subject(:consumer) { karafka_consumer_for(:xml_data) }

  let(:message_content) { "home-#{rand}" }
  let(:params) { consumer.send(:params) }

  before do
    publish_for_karafka("<message><new>#{message_content}</new></message>")
    allow(Karafka.logger).to receive(:info)
  end

  it 'expects to log a proper message' do
    expect(Karafka.logger).to receive(:info).with("Consumed following message: #{params}")
    consumer.consume
  end

  it 'expects to unparse message' do
    consumer.consume
    expect(params.payload['message']['new']).to eq message_content
  end
end
