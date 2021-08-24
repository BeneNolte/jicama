Rails.application.routes.draw do
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root to: 'pages#home'

  # get "dashboard", to: "pages#dashboard"
  get "login", to: "pages#login"

	resources :datasources, only: [ :show ] do
		resources :locations, only: [ :index, :update ]
		resources :data_ownerships, only: [ :index, :update ]
  end



  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
