Rails.application.routes.draw do
  root "home#index"
  get "up" => "rails/health#show", as: :rails_health_check

  # Auth routes
  get "/auth/github", to: "sessions#new", as: :auth_request
  get "/auth/github/callback", to: "sessions#create", as: :callback_auth
  delete "/logout", to: "sessions#destroy"

  get "rollbar/test" => "rollbar#test" if Rails.env.development?
end
