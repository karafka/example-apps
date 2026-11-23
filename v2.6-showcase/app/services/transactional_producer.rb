# frozen_string_literal: true

# Transactional WaterDrop producer used for atomic multi-topic fan-out
#
# Kafka allows one active producer per `transactional.id`, so each process (and each
# `karafka swarm` node, which is a fork) builds its own producer with its own id.
module TransactionalProducer
  @mutex = Mutex.new

  class << self
    # @return [WaterDrop::Producer] transactional producer of the current process
    def instance
      @mutex.synchronize do
        return @producer if @producer && @pid == Process.pid

        @pid = Process.pid
        @producer = build
      end
    end

    # Closes the producer of the current process, if it was built
    def close
      @mutex.synchronize do
        @producer&.close if @pid == Process.pid
        @producer = nil
      end
    end

    private

    # @return [WaterDrop::Producer]
    def build
      WaterDrop::Producer.new do |config|
        config.logger = Karafka.logger
        config.kafka = Karafka::App.config.kafka.merge(
          'transactional.id': "showcase-#{Socket.gethostname}-#{Process.pid}"
        )
      end
    end
  end
end
