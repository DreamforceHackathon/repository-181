Rails.application.routes.draw do
  devise_for :users,
             only: [:omniauth_callbacks],
             controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  resources :sequences do
    resources :entries do
      collection do
        post :ignore
      end
    end

    member do
      get 'chart'
    end
  end

  resource :user do
    member do
      get 'logout'
      post 'configure_sfdc'
      post 'email'
    end
  end

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root "application#index"
  get '*path' => 'application#index'
end
