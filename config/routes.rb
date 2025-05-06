Rails.application.routes.draw do
  # Devise Token Auth (mantenha como está)
  mount_devise_token_auth_for "User", at: "auth", skip: [ :omniauth_callbacks ]

  # Rotas de API (versionadas - boa prática)
  namespace :api do
    namespace :v1 do
      resources :cars, only: [ :index, :show, :create, :update, :destroy ]
      resources :tracks, only: [ :index, :show, :create, :update, :destroy ]
      resources :races, only: [ :index, :show, :create, :update, :destroy ]

      # Rotas de usuário seguras
      resources :users, only: [ :index, :show, :create, :update, :destroy ] do
        collection do
          # Rota para o usuário logado
          get "me", to: "users#me"

          # Rota para atualização de dados do perfil
          patch "me", to: "users#update_profile"
        end
      end
    end
  end

  # Health Check (opcional)
  get "status", to: "health#check"
end
