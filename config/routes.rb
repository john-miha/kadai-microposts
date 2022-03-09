Rails.application.routes.draw do
  get 'users/index'
  get 'users/show'
  get 'users/new'
  get 'users/create'
  get 'toppages/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "toppages#index"
  
  get 'signup', to: 'users#new'
  resources :users, only: [:index, :show, :create]
end
