ENV['KARAFKA_ENV'] ||= 'development'

Bundler.require(:default, ENV['KARAFKA_ENV'])

# App class
class App < Karafka::App
  setup do |config|
    config.kafka_hosts = %w( 127.0.0.1:9093 )
    config.zookeeper_hosts = %w( 127.0.0.1:2181 )
    config.worker_timeout = 60 # 1 minute
  end
end

Karafka::Loader.new.load(App.root)
