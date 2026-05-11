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
  rescue StandardError => e
    Rails.logger.error "Failed to update repository info: #{e.message}"
    nil
  end

  private

  def github_client
    client_class = ApplicationContainer[:github_client]
    client_class.new
  end
end
