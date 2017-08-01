Rails.application.routes.draw do
  devise_for :users
  root to: 'posts#index'

  resources :posts, only: [:index, :new, :create, :show]

  #get '', to.'session' as: :login
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
