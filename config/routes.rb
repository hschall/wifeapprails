Rails.application.routes.draw do
  # Devise routes for user authentication
  devise_for :users

  # Resourceful routes for records
  resources :records

  # Admin namespace for user management
  namespace :admin do
    get 'users/index'
    get 'users/edit'
    get 'users/update'
    resources :users, only: [:index, :edit, :update] # Admin user management routes
  end

  # Home and root routes
  get 'home/master'
  root 'records#index'

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check
end

