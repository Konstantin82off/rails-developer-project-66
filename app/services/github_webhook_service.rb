# frozen_string_literal: true

class GithubWebhookService
  def self.install(repository)
    return if Rails.env.test?

    client = Octokit::Client.new(access_token: repository.user.token, auto_paginate: true)

    webhook_url = Rails.application.routes.url_helpers.api_checks_url(
      host: ENV.fetch("BASE_URL", "localhost:3000")
    )

    client.create_hook(
      repository.full_name,
      "web",
      {
        url: webhook_url,
        content_type: "json"
      },
      {
        events: [ "push" ],
        active: true
      }
    )
  rescue Octokit::Error => e
    Rails.logger.error "Failed to create webhook for #{repository.full_name}: #{e.message}"
  end
end
