Rails.application.routes.draw do
  resources :sequences do
    resources :entries

    member do
      get 'chart'
    end
  end

  root "application#index"
  get '*path' => 'application#index'
end
