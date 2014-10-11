Rails.application.routes.draw do
  resources :sequences do
    resources :entries
  end
end
