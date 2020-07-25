Rails.application.routes.draw do
  post "/login", to: "auth#login"
  get "/auto_login", to: "auth#auto_login"
  get "/user_is_authed", to: "auth#user_is_authed"
  post "/employees", to: "employees#create"
  get "/slack/users", to: "sessions#users"
  get "/slack/topmessages", to: "channels#top_channel_messages"
  get "/coworkers", to: "employees#index"
  # resources :reviews
  # resources :skills
  get "/auth/callback", to: 'sessions#create'
  get "/feedback/received", to: "reviews#received"
  get "/feedback/given", to: "reviews#given"
  post "/feedback/request", to: "reviews#request_feedback"
  resources :reviews
  resources :skills
  resources :employees
  resources :organizations
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
