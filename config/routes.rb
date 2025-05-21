Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  mount_devise_token_auth_for "User", at: "auth", skip: [:omniauth_callbacks]


  namespace :api do
    namespace :v1 do
      resources :cars, only: [:index, :show, :create, :update, :destroy]
      resources :tracks, only: [:index, :show, :create, :update, :destroy]
      resources :races, only: [:index, :show, :create, :update, :destroy]


      resources :users, only: [:index, :show, :create, :update, :destroy] do
        collection do
          get "me"
          patch "me", to: "users#update_profile"
        end
      end
    end
  end

  get "status", to: "health#check"
end
