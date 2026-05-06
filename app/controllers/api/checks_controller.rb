# frozen_string_literal: true

class Api::ChecksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    payload = JSON.parse(request.body.read)

    repository = Repository.find_by(full_name: payload['repository']['full_name'])

    if repository
      commit_id = payload['after'].presence || 'unknown'
      check = repository.checks.create!(commit_id: commit_id, passed: false)
      RepositoryCheckJob.perform_now(check.id)

      render json: { id: repository.id, full_name: repository.full_name }, status: :ok
    else
      head :not_found
    end
  rescue JSON::ParserError => e
    Rails.logger.error "JSON parsing error: #{e.message}"
    head :unprocessable_content
  rescue StandardError => e
    Rails.logger.error "Webhook error: #{e.message}"
    head :unprocessable_content
  end
end
