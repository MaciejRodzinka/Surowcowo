Rails.application.routes.draw do
  root 'main#index'
  resources :entries
end
