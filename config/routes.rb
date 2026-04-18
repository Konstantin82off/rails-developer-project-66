Rails.application.routes.draw do
  namespace :api do
    post "/checks", to: "webhooks#create"
  end

  root "home#index"
  get "up" => "rails/health#show", as: :rails_health_check

  # Auth routes
  get "/auth/github", to: "sessions#new", as: :auth_request
  get "/auth/github/callback", to: "sessions#create", as: :callback_auth
  delete "/logout", to: "sessions#destroy"

  # Repositories routes with nested checks
  resources :repositories, only: [ :index, :new, :create, :show ] do
    resources :checks, only: [ :create, :show ], module: :repositories
  end

  get "rollbar/test" => "rollbar#test" if Rails.env.development?

  # Test route for authentication in tests
  if Rails.env.test?
    post "/login_as_user", to: "sessions#login_as_user"
  end
end
