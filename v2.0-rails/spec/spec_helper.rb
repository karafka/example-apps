# frozen_string_literal: true

ENV['RAILS_ENV'] = 'test'

require 'karafka/testing/rspec/helpers'

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.order = :random
  config.include Karafka::Testing::RSpec::Helpers
end

require './karafka'
