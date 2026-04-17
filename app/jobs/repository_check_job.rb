# frozen_string_literal: true

class RepositoryCheckJob < ApplicationJob
  queue_as :default

  def perform(check_id)
    service = RepositoryCheckService.new(check_id)
    service.perform
  end
end
