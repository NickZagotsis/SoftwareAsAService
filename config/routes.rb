Rails.application.routes.draw do
  get "messages/index"
  get "rooms/show"
  get "profiles/show"
  get "friends/index"
  get "friends/show"
  resources :posts
  devise_for :users
  resources :friendships, only: [ :create, :update, :destroy ]
  resources :profiles, only: [ :show ]
  root "home#index"
  resources :rooms, only: [ :index, :show, :new, :create, :destroy ] do
    resources :messages, only: [ :create ]
  end

  #  change this when you create posts
  # authenticated :user do
  #   root 'posts#index', as: :authenticated_root
  # end

  # unauthenticated do
  #   root 'home#index', as: :unauthenticated_root
  # end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  post "private_chat", to: "rooms#private_chat", as: :private_chat
  get "personal_chats", to: "rooms#personal", as: "personal_chats"


  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
