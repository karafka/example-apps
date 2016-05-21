ENV['RACK_ENV'] ||= 'development'
ENV['KARAFKA_ENV'] ||= ENV['RACK_ENV']

Bundler.require(:default, ENV['KARAFKA_ENV'])

Karafka::Loader.new.load(Karafka::App.root)

# App class
class App < Karafka::App
  setup do |config|
    # Karafka will autodiscover kafka_hosts based on Zookeeper but we need it set manually
    # to run tests without running kafka and zookeper
    config.kafka = { hosts: %w( 127.0.0.1:9092 ) }
    config.zookeeper = { hosts: %w( 127.0.0.1:2181 ) }
    config.wait_timeout = 60 # 1 minute
    config.max_concurrency = 5
    config.name = 'example_app'
    config.redis = {
      url: 'redis://localhost:6379'
    }

    routes.draw do
      topic :aspected_messages do
        controller AspectedMessagesController
      end

      topic :basic_messages do
        controller BasicMessagesController
        parser XmlParser
      end

      topic :interchanger_messages do
        controller InterchangerMessagesController
        interchanger Base64Interchanger
      end

      topic :other_messages do
        controller OtherMessagesController
        worker DifferentWorker
      end
    end
  end
end
