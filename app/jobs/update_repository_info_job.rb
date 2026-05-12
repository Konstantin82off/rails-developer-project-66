# frozen_string_literal: true

class UpdateRepositoryInfoJob < ApplicationJob
  queue_as :default

  def perform(repository_id)
    repository = Repository.find(repository_id)
    service = RepositoryInfoService.new(repository)
    service.update_from_github

    # После успешного обновления создаём и запускаем проверку
    check = repository.checks.create!(commit_id: 'pending', passed: false, aasm_state: 'created')
    RepositoryCheckJob.perform_later(check.id)
  end
end
