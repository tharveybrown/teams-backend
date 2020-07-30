Rails.application.routes.draw do
  post "/login", to: "auth#login"
  get "/auto_login", to: "auth#auto_login"
  get "/user_is_authed", to: "auth#user_is_authed"
  post "/employees", to: "employees#create"
  get "/slack/users", to: "sessions#users"
  get "/slack/topchannels", to: "channels#top_channels"
  get "/channel/:id/personalities", to: "channels#personality"
  get '/channel/:id/keywords', to: "channels#channel_keywords"
  get "/coworkers", to: "employees#index"
  get '/analysis_metadata/personalities', to: 'analysis_metadata#personalities'
  # get '/channel/:id/personalities', to: 'personalities#personality'
  get 'channels', to: 'channels#index'
  get '/employees/engagement', to: "employees#engagement"
  # resources :reviews
  # resources :skills
  post "/employee/delete", to: "employees#remove_subordinate"
  post "employee/add", to: "employees#add_employee"
  post "manager/add", to: "employees#add_manager"
  get "/auth/callback", to: 'sessions#create'
  get "/feedback/received", to: "reviews#received"
  get "/feedback/given", to: "reviews#given"
  post "/feedback/request", to: "reviews#request_feedback"
  resources :reviews
  resources :skills
  resources :employees, only: [:create, :show, :index, :destroy, :update]
  resources :organizations
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
