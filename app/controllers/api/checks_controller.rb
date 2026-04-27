# frozen_string_literal: true

class Api::ChecksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    payload = JSON.parse(request.body.read)

    repository = Repository.find_by(full_name: payload["repository"]["full_name"])

    if repository.nil?
      head :not_found
      return
    end

    # Если commit_id не передан, используем значение по умолчанию
    commit_id = payload["after"].presence || "unknown"

    check = repository.checks.new(commit_id: commit_id)

    if check.save
      RepositoryCheckJob.perform_later(check.id)
      render json: { id: repository.id, full_name: repository.full_name }, status: :ok
    else
      render json: { errors: check.errors.full_messages }, status: :unprocessable_entity
    end
  rescue JSON::ParserError => e
    render json: { error: "Invalid JSON: #{e.message}" }, status: :bad_request
  end
end
