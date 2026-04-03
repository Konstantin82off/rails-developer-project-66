Rails.application.routes.draw do
  root "home#index"
  get "up" => "rails/health#show", as: :rails_health_check
  get "rollbar/test" => "rollbar#test" if Rails.env.development?
end
