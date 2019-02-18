# frozen_string_literal: true

source 'https://rubygems.org'

# ActiveSupport is only used to parse XML
gem 'activesupport'

gem 'karafka', git: 'https://github.com/karafka/karafka'
gem 'karafka-sidekiq-backend', git: 'https://github.com/karafka/sidekiq-backend'
gem 'waterdrop', git: 'https://github.com/karafka/waterdrop'

group :development, :test do
  gem 'byebug'
  gem 'karafka-testing', git: 'https://github.com/karafka/testing'
  gem 'rspec'
  gem 'simplecov'
end
