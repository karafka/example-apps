Gem::Specification.new do |spec|
  spec.name          = 'dummy_kafka'
  spec.version       = '1.0.0'
  spec.authors       = ['Me']
  spec.email         = ['me@example.com']
  spec.summary       = 'Basic setup for kafka/karafka'
  spec.homepage      = 'https://example.com'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.1.0')
  spec.files = ['lib']
  spec.require_paths = ['lib']

  spec.add_dependency 'karafka', '~> 2.0.11'
end
