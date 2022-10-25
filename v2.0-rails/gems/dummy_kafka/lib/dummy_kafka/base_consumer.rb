module DummyKafka
  class BaseConsumer < Karafka::BaseConsumer
    def consume
      puts 'Look at me. I am doing cool stuff here!'
    end
  end
end
