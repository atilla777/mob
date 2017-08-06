Rails.application.routes.draw do
  require 'sidekiq/web'

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users

  root to: 'posts#index'

  resources :posts do
    resources :comments, only: [:create, :update, :destroy]
    resources :votes, only: [:create]
  end

  #get '', to.'session' as: :login
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
