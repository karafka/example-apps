require 'karafka'

module DummyKafka
  class App < Karafka::App

    setup do |config|
      config.max_wait_time = 500
      config.concurrency = 1
    end

  end
end
