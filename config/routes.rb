Rails.application.routes.draw do
  get '/auth/slack/callback', to: 'sessions#create'
  resources :reviews
  resources :skills
  resources :employees
  resources :organizations
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
