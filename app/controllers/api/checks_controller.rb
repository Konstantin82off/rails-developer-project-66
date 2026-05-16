# frozen_string_literal: true

class Api::ChecksController < Api::ApplicationController
  def create
    full_name = params['repository']['full_name']

    repository = Repository.find_by(full_name: full_name)

    if repository
      commit_id = params['after'].presence || 'pending'
      check = repository.checks.create!(commit_id: commit_id, passed: false)
      RepositoryCheckJob.perform_later(check.id)

      render json: { id: repository.id, full_name: repository.full_name }, status: :ok
    else
      head :not_found
    end
  rescue StandardError => e
    Rails.logger.error "Webhook error: #{e.message}"
    head :unprocessable_content
  end
end
