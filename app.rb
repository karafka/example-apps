ENV['KARAFKA_ENV'] ||= 'development'

Bundler.require(:default, ENV['KARAFKA_ENV'])

# App class
class App < Karafka::App
  setup do |config|
    config.kafka_hosts = %w( 127.0.0.1:9092 )
    config.zookeeper_hosts = %w( 127.0.0.1:2181 )
    config.worker_timeout = 60 # 1 minute
    config.concurrency = 5
    config.name = 'example_app'
    config.redis_url = 'redis://localhost:6379'
    config.redis_namespace = 'example_app'
  end
end

Karafka::Loader.new.load(App.root)
