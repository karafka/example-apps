# frozen_string_literal: true

require 'resolv-replace.rb'

# We can generate messages in two ways: Using aspects and generate any message
# to any kafka topic using custom event.
# class which generate messages in aspect and in basic way
class Generator
  # Sends messages which are written in 'aspects' folder for sum method
  # Sends messages directly to Kafka server using WaterDrop::Message class
  def send_messages
    Calculator.new.sum(5, 6)
    WaterDrop::SyncProducer.call('<message><new>home</new></message>', topic: 'basic_messages')
    WaterDrop::SyncProducer.call("\x0Efoo@test.com\x12\x06barbaz", topic: 'interchanger_messages')

    # Note that Karafka is fast and it might not be enough to process more than 1-5 per
    # batch received
    20.times do
      WaterDrop::SyncProducer.call({ number: rand }.to_json, topic: 'batch_processed_messages')
    end
  end
end
