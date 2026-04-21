# frozen_string_literal: true

module Api
  class WebhooksController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
      payload = JSON.parse(request.body.read)

      repository = Repository.find_by(full_name: payload["repository"]["full_name"])

      if repository
        check = repository.checks.create!(commit_id: payload["after"])
        RepositoryCheckJob.perform_later(check.id)

        render json: { id: repository.id, full_name: repository.full_name }, status: :ok
      else
        head :not_found
      end
    rescue JSON::ParserError, StandardError => e
      Rails.logger.error "Webhook error: #{e.message}"
      head :unprocessable_entity
    end
  end
end
