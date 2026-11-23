# frozen_string_literal: true

require 'karafka/web'

Rails.application.routes.draw do
  resources :orders, only: %i[index show create]

  mount Karafka::Web::App, at: '/karafka'
end
