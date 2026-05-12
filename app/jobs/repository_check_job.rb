# frozen_string_literal: true

class RepositoryCheckJob < ApplicationJob
  queue_as :default
  retry_on StandardError, wait: 5.seconds, attempts: 3

  def perform(check_id)
    check = Repository::Check.find(check_id)
    repository = check.repository

    # Если данные репозитория ещё не загружены, получаем из GitHub
    if repository.clone_url.nil?
      client = github_client(repository.user.token)
      github_repo = client.repository(repository.github_id)

      repository.update!(
        name: github_repo.name,
        full_name: github_repo.full_name,
        language: github_repo.language.downcase,
        clone_url: github_repo.clone_url,
        ssh_url: github_repo.ssh_url
      )
    end

    service = RepositoryCheckService.new(check_id)
    service.perform
  end

  private

  def github_client(token)
    client_class = ApplicationContainer[:github_client]
    client_class.new(access_token: token, auto_paginate: true)
  end
end
