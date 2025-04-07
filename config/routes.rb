Rails.application.routes.draw do
  # Devise Token Auth (mantenha como está)
  mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks]

  # Rotas de API (versionadas - boa prática)
  namespace :api do
    namespace :v1 do
      resources :cars, only: [:index, :show, :create, :update, :destroy]
      resources :tracks, only: [:index, :show]
      resources :races, only: [:index, :show, :create, :update, :destroy]

      # Rotas de usuário seguras
      resources :users, only: [:index, :show, :destroy] do
        collection do
          get 'me', to: 'users#me'
          patch 'me', to: 'users#update_profile'
        end
      end
    end
  end

  # Health Check (opcional)
  get 'status', to: 'health#check'
end
