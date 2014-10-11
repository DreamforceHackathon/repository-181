Rails.application.routes.draw do
  resources :sequences do
    resources :entries
  end

  root "application#chart"
end
