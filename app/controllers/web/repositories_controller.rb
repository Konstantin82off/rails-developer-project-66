# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  before_action :authenticate_user!

  def index
    @repositories = policy_scope(Repository).page(params[:page])
    render :index
  end

  def show
    @repository = Repository.find(params[:id])
    authorize @repository
    @checks = @repository.checks.order(created_at: :desc).page(params[:page])
    render :show
  end

  def new
    @github_repos = fetch_cached_user_repositories
    render :new
  end

  def create
    @repository = current_user.repositories.find_or_initialize_by(repository_params)

    if @repository.save
      UpdateRepositoryInfoJob.perform_later(@repository.id)
      redirect_to repositories_path, notice: t('flash.repository_added', name: @repository.github_id)
    else
      redirect_to new_repository_path, alert: @repository.errors.full_messages.join(', ')
    end
  end

  private

  def repository_params
    params.expect(repository: [:github_id])
  end

  def fetch_cached_user_repositories
    return [] unless current_user

    cache_key = "user_repositories_#{current_user.id}"
    Rails.cache.fetch(cache_key, expires_in: 1.hour) do
      github_service.fetch_user_repositories(exclude_ids: current_user.repositories.pluck(:github_id))
    end
  rescue StandardError => e
    Rails.logger.error "Failed to fetch repositories: #{e.message}"
    []
  end

  def github_client
    client_class = ApplicationContainer[:github_client]

    if Rails.env.test?
      client_class.new
    else
      client_class.new(access_token: current_user.token, auto_paginate: true)
    end
  end

  def github_service
    @github_service ||= GithubRepositoryService.new(github_client)
  end
end
