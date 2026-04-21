Rails.application.routes.draw do
  namespace :api do
    post "/checks", to: "webhooks#create"
  end

  scope module: :web do
    root "home#index"

    # Auth routes
    get "/auth/github", to: "auth#callback", as: :auth_request
    get "/auth/github/callback", to: "auth#callback", as: :callback_auth
    delete "/logout", to: "auth#destroy"

    # Repositories routes with nested checks
    resources :repositories, only: [ :index, :new, :create, :show ] do
      resources :checks, only: [ :create, :show ], module: :repositories
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
  get "rollbar/test" => "rollbar#test" if Rails.env.development?

  # Test route for authentication in tests
  if Rails.env.test?
    post "/login_as_user", to: "web/auth#login_as_user"
  end
end
