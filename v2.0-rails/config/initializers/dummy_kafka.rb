# There may be some logic that require to use "reloader.to_prepare"
Rails.application.reloader.to_prepare do
  # Some logic based on which just required components are loaded
  if ENV.fetch('LOAD_CONSUMERS_CODE', false) == 'true'
    DummyKafka.load_code_for_consumers
  end
end
