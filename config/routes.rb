Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidekiq/cron/web'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
#  devise_scope :user do
#    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
#  end

  root to: 'posts#index'

  resource :pictures, only: [:create, :destroy]

  resources :posts do
    resources :comments, only: [:create, :update, :destroy]
    resources :votes, only: [:create]
  end

  post '/posts/set_stars', to: 'posts#set_stars', as: :set_stars

  #get '', to.'session' as: :login
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
