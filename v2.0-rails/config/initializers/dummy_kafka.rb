Rails.application.reloader.to_prepare do
  if ENV.fetch('LOAD_CONSUMERS_CODE', false) == 'true'
    DummyKafka.load_code_for_consumers
  end
end
