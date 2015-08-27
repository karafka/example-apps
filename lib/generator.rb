require 'resolv-replace.rb'

# We can generate messages in two ways: Using aspects and generate any message
# to any kafka topic using custom event.
# class which generate messages in aspect and in basic way
class Generator
  # Sends messages which are written in 'aspects' folder for sum method
  # Sends messages directly to Kafka server using WaterDrop::Message class
  def send_messages
    Calculator.new.sum(5, 6)

    WaterDrop::Message.new('basic_messages', 'String message').send!

    hash_message = {
      name: 'John',
      surname: 'Doe'
    }

    WaterDrop::Message.new(:basic_messages, hash_message).send!
  end
end
