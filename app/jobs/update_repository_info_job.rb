# frozen_string_literal: true

class UpdateRepositoryInfoJob < ApplicationJob
  queue_as :default

  def perform(repository_id)
    repository = Repository.find(repository_id)
    service = RepositoryInfoService.new(repository)
    service.update_from_github
  end
end
