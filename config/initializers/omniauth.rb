OmniAuth.config.logger = Rails.logger
OmniAuth.config.allowed_request_methods = [ :get, :post ]
OmniAuth.config.silence_get_warning = true

OmniAuth.config.full_host = lambda do |env|
  if Rails.env.development?
    "http://localhost:3000"
  else
    "https://rails-developer-project-66.onrender.com"
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github,
    ENV.fetch("GITHUB_CLIENT_ID", nil),
    ENV.fetch("GITHUB_CLIENT_SECRET", nil),
    scope: "user,public_repo,admin:repo_hook",
    provider_ignores_state: true
end
