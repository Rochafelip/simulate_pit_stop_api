Rails.application.routes.draw do
 get '/', to: proc { [200, {}, ['API Simulate Pit Stop']] }

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for "User", at: "auth", skip: [:omniauth_callbacks]

      resources :cars, only: [:index, :show, :create, :update, :destroy]
      resources :tracks, only: [:index, :show, :create, :update, :destroy]
      resources :races, only: [:index, :show, :create, :update, :destroy]
      resources :users, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
