require 'karafka'

module DummyKafka
  def self.load_code_for_consumers
    require_relative 'dummy_kafka/app'
    require_relative 'dummy_kafka/base_consumer'
  end
end
