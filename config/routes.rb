# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    post "/checks", to: "webhooks#create"
  end

  scope module: :web do
    root "home#index"

    get "/auth/github", to: "auth#check_github_auth", as: :auth_request
    post "/auth/github", to: "auth#check_github_auth", as: :auth_post_request
    get "/auth/github/callback", to: "auth#callback", as: :callback_auth
    delete "/logout", to: "auth#destroy"

    resources :repositories, only: [ :index, :new, :create, :show ] do
      resources :checks, only: [ :create, :show ], module: :repositories
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
  get "rollbar/test" => "rollbar#test" if Rails.env.development?

  if Rails.env.test?
    post "/login_as_user", to: "web/auth#login_as_user"
  end
end
