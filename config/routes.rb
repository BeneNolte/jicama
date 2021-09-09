Rails.application.routes.draw do
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root to: 'pages#home'

  get "dashboard", to: "pages#dashboard"
  get "login", to: "pages#login"
  get "oauth2callback", to: "pages#google"

	resources :datasources, only: [ :show, :update ] do
    get "tuto", to: "pages#tuto"
		resources :locations, only: [ :index, :update ]
		resources :data_ownerships, only: [ :index, :update ]
  end

  resources :data_ownerships do
    collection do
      patch 'filter', to: 'data_ownerships#filter'
    end
  end

  # Sidekiq Web UI, only for admins.
  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
