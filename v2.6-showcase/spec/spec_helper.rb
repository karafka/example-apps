# frozen_string_literal: true

ENV['RAILS_ENV'] = 'test'

require 'karafka/testing/rspec/helpers'

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.order = :random
  config.include Karafka::Testing::RSpec::Helpers

  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end

require File.expand_path('../config/environment', __dir__)
require './karafka'
