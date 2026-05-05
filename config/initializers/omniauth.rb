# frozen_string_literal: true

OmniAuth.config.full_host = if Rails.env.development?
                              'http://localhost:3000'
                            else
                              'https://rails-developer-project-66.onrender.com'
                            end

Rails.application.config.middleware.use OmniAuth::Builder do
  github_options = { scope: 'user,public_repo,admin:repo_hook' }
  github_options[:provider_ignores_state] = true if Rails.env.development?

  provider :github,
           ENV.fetch('GITHUB_CLIENT_ID', nil),
           ENV.fetch('GITHUB_CLIENT_SECRET', nil),
           github_options
end

OmniAuth.config.test_mode = true if Rails.env.test?
