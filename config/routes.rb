Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  # Definindo as rotas para cada controlador
  resources :cars, only: [:index, :show, :create, :update, :destroy]
  resources :tracks, only: [:index, :show, :create, :update, :destroy]
  resources :races, only: [:index, :show, :create, :update, :destroy]
  resources :users, only: [:index, :show, :create, :update, :destroy]
  
end
