Rails.application.routes.draw do
  # == Authentication (fora do namespace) ==
  mount_devise_token_auth_for "User", at: "auth", skip: [:omniauth_callbacks]

  # == API ==
  namespace :api do
    namespace :v1 do
      # == Resources ==
      resources :cars, only: [:index, :show, :create, :update, :destroy]
      resources :tracks, only: [:index, :show, :create, :update, :destroy]
      resources :races, only: [:index, :show, :create, :update, :destroy]

      # == Users ==
      resources :users, only: [:index, :show, :create, :update, :destroy] do
        collection do
          get "me"
          patch "me", to: "users#update_profile"
        end
      end
    end
  end

  # == Monitoring ==
  get "status", to: "health#check"
end
