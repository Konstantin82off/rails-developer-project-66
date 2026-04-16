# frozen_string_literal: true

class Repositories::ChecksController < ApplicationController
  before_action :authenticate_user!
  before_action :load_repository

  def create
    @check = @repository.checks.create!(commit_id: fetch_latest_commit_sha)
    @check.start_clone!

    # TODO: Запускаем проверку в фоне (будет реализовано позже)
    # RepositoryCheckJob.perform_later(@check.id)

    redirect_to repository_check_path(@repository, @check), notice: "Check was created and is being processed"
  end

  def show
    @check = @repository.checks.find(params[:id])
  end

  private

  def load_repository
    @repository = current_user.repositories.find(params[:repository_id])
  end

  def fetch_latest_commit_sha
    client_class = ApplicationContainer[:github_client]
    client = client_class.new(access_token: current_user.token, auto_paginate: true)
    client.commits(@repository.full_name).first.sha
  rescue Octokit::Error => e
    Rails.logger.error "GitHub API error: #{e.message}"
    nil
  end
end
