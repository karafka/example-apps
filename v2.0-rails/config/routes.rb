Rails.application.routes.draw do
  root 'main#show'

  resources :visitors, only: %i[index show]
end
