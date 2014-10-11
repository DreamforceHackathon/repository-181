Rails.application.routes.draw do
  devise_for :users,
             only: [:omniauth_callbacks],
             controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  resources :sequences do
    resources :entries

    member do
      get 'chart'
    end
  end

  resource :user

  root "application#index"
  get '*path' => 'application#index'
end
