Rails.application.routes.draw do
  devise_for :users, only: [] # Devise throws a bitch fit if the devise_for isn't in place, even without routes

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
