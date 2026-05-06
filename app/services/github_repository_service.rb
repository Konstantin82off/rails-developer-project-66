# frozen_string_literal: true

class GithubRepositoryService
  def initialize(client)
    @client = client
  end

  def fetch_user_repositories(exclude_ids: [])
    @client.repos.reject { |r| exclude_ids.include?(r.id) }
  rescue StandardError => e
    Rails.logger.error "GitHub API error: #{e.message}"
    []
  end

  def fetch_repository_by_id(github_id)
    @client.repository(github_id.to_i)
  rescue StandardError => e
    Rails.logger.error "GitHub API error: #{e.message}"
    nil
  end

  def setup_webhook(repo_full_name, webhook_url)
    return if webhook_exists?(repo_full_name, webhook_url)

    create_webhook(repo_full_name, webhook_url)
  rescue StandardError => e
    Rails.logger.error "Failed to create webhook for #{repo_full_name}: #{e.message}"
    false
  end

  private

  def webhook_exists?(repo_full_name, webhook_url)
    hooks = @client.hooks(repo_full_name)
    hooks.any? { |hook| hook.config.url == webhook_url }
  end

  def create_webhook(repo_full_name, webhook_url)
    @client.create_hook(
      repo_full_name,
      'web',
      { url: webhook_url, content_type: 'json' },
      { events: ['push'], active: true }
    )
  end
end
