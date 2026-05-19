# frozen_string_literal: true

class UpdateRepositoryInfoJob < ApplicationJob
  queue_as :default

  def perform(repository_id)
    repository = Repository.find(repository_id)
    client = github_client(repository.user.token)
    github_repo = client.repository(repository.github_id)

    language = github_repo.language&.downcase

    # Если язык не поддерживается - удаляем репозиторий
    unless Repository::SUPPORTED_LANGUAGES.include?(language)
      repository.destroy
      Rails.logger.info "Repository #{repository.github_id} deleted: unsupported language #{language}"
      return
    end

    # Обновляем репозиторий данными из GitHub
    repository.update!(
      name: github_repo.name,
      full_name: github_repo.full_name,
      language: language,
      clone_url: github_repo.clone_url,
      ssh_url: github_repo.ssh_url
    )

    # Создаём проверку
    check = repository.checks.create!(commit_id: 'pending', passed: false, aasm_state: 'created')
    RepositoryCheckJob.perform_later(check.id)
  end

  private

  def github_client(token)
    client_class = ApplicationContainer[:github_client]
    client_class.new(access_token: token, auto_paginate: true)
  end
end
