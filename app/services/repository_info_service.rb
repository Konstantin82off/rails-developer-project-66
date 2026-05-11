# frozen_string_literal: true

class RepositoryInfoService
  def initialize(repository)
    @repository = repository
  end

  def update_from_github
    client = github_client
    github_repo = client.repository(@repository.github_id)

    @repository.update!(
      name: github_repo.name,
      full_name: github_repo.full_name,
      language: github_repo.language.downcase,
      clone_url: github_repo.clone_url,
      ssh_url: github_repo.ssh_url
    )

    # Создаём вебхук после обновления информации
    setup_webhook
  rescue StandardError => e
    Rails.logger.error "Failed to update repository info: #{e.message}"
    nil
  end

  private

  def github_client
    client_class = ApplicationContainer[:github_client]
    client_class.new
  end

  def setup_webhook
    webhook_url = Rails.application.routes.url_helpers.api_checks_url
    client = github_client

    # Проверяем, существует ли уже вебхук
    hooks = client.hooks(@repository.full_name)
    has_check_hook = hooks.any? { |hook| hook.config.url == webhook_url }

    return if has_check_hook

    # Создаём новый вебхук
    client.create_hook(
      @repository.full_name,
      'web',
      { url: webhook_url, content_type: 'json' },
      { events: ['push'], active: true }
    )
  rescue StandardError => e
    Rails.logger.error "Failed to create webhook for #{@repository.full_name}: #{e.message}"
  end
end
