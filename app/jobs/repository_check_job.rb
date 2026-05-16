# frozen_string_literal: true

class RepositoryCheckJob < ApplicationJob
  queue_as :default
  retry_on StandardError, wait: 5.seconds, attempts: 3

  def perform(check_id)
    check = Repository::Check.find(check_id)
    repository = check.repository
    git = ApplicationContainer[:git]
    bash_runner = ApplicationContainer[:bash_runner]

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

    repo_path = Rails.root.join("tmp/repositories/#{repository.id}")
    git.clone_repository(repository.clone_url, repo_path.to_s)

    commit_id_command = "cd #{repo_path} && git rev-parse --short HEAD"
    commit_id_output, exit_status = bash_runner.execute(commit_id_command)

    if exit_status.zero? && commit_id_output.present?
      check.update!(commit_id: commit_id_output.strip)
    end

    service = RepositoryCheckService.new(check_id)
    service.perform

    FileUtils.rm_rf(repo_path)
  end

  private

  def github_client(token)
    client_class = ApplicationContainer[:github_client]
    client_class.new(access_token: token, auto_paginate: true)
  end
end
