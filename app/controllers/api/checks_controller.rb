# frozen_string_literal: true

class Api::ChecksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    payload = JSON.parse(request.body.read)

    repository = Repository.find_by(full_name: payload["repository"]["full_name"])

    if repository
      check = repository.checks.new(commit_id: payload["after"])

      if check.save
        RepositoryCheckJob.perform_later(check.id)
        render json: { id: repository.id, full_name: repository.full_name }, status: :ok
      else
        head :unprocessable_entity
      end
    else
      head :not_found
    end
  rescue JSON::ParserError
    head :bad_request
  end
end
