::WaterDrop.setup do |config|
  config.send_messages = true
  config.kafka_hosts = ['127.0.0.1:9092']
  config.connection_pool_size = 25
  config.connection_pool_timeout = 1
  config.raise_on_failure = true
end
