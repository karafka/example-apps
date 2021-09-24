# frozen_string_literal: true

require 'bundler'
require 'rake'
require 'rspec/core/rake_task'
require './karafka'
load './lib/tasks/sender.rake'

RSpec::Core::RakeTask.new(:spec)
task default: :spec
