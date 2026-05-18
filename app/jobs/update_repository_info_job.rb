# frozen_string_literal: true

class UpdateRepositoryInfoJob < ApplicationJob
  queue_as :default

  def perform(repository_id)
    repository = Repository.find(repository_id)

    return if repository.language.blank?

    check = repository.checks.create!(commit_id: 'pending', passed: false, aasm_state: 'created')
    RepositoryCheckJob.perform_later(check.id)
  end
end
