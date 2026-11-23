# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'

Bundler.require(*Rails.groups)

# Showcase app main module
module Showcase
  # Orders -> payments -> inventory -> notifications showcase on Karafka
  class Application < Rails::Application
    config.load_defaults 8.0
    config.api_only = false

    # Pro consumers come with the Pro layer and must not load in a license-free run
    Rails.autoloaders.main.ignore(Rails.root.join('app/consumers/pro')) unless Karafka.pro?
  end
end
