# frozen_string_literal: true

Rails.application.configure do
  config.enable_reloading = false
  # Eager load in specs so a license-free run proves no Pro code loads
  config.eager_load = true
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.action_controller.allow_forgery_protection = false
  config.action_dispatch.show_exceptions = :none
  config.active_support.deprecation = :stderr
end
