::WaterDrop.setup do |config|
  config.send_messages = true
  config.kafka_host = '127.0.0.1'
  config.kafka_ports = ['9093']
  config.connection_pool_size = 25
  config.connection_pool_timeout = 1
end