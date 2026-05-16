# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  before_action :authenticate_user!

  def index
    @repositories = policy_scope(Repository)
    render :index
  end

  def show
    @repository = Repository.find(params[:id])
    authorize @repository
    @checks = @repository.checks.order(created_at: :desc)
    render :show
  end

  def new
    @github_repos = github_service.fetch_user_repositories(exclude_ids: current_user.repositories.pluck(:github_id))
    @repositories = current_user.repositories
    render :new
  end

  def create
    github_id = params[:repository][:github_id]

    if github_id.blank?
      redirect_to_new_repository_path(t('.github_cannot_be_blank'))
      return
    end

    github_repo = github_service.fetch_repository_by_id(github_id)

    if github_repo.nil?
      redirect_to_new_repository_path(t('flash.repository_not_found'))
      return
    end

    return redirect_to_new_repository_path(t('flash.repository_not_supported')) unless supported_language?(github_repo)
    return redirect_to_new_repository_path(t('flash.repository_already_added')) if repository_exists?(github_repo.id)

    repository = create_repository(github_repo)
    schedule_background_jobs(repository)

    redirect_to repositories_path, notice: t('flash.repository_added', name: repository.name)
  end

  private

  def redirect_to_new_repository_path(alert_message)
    redirect_to new_repository_path, alert: alert_message
  end

  def supported_language?(github_repo)
    %w[ruby javascript].include?(github_repo.language&.downcase)
  end

  def repository_exists?(github_id)
    current_user.repositories.exists?(github_id: github_id)
  end

  def create_repository(github_repo)
    current_user.repositories.create!(
      name: github_repo.name,
      github_id: github_repo.id,
      full_name: github_repo.full_name,
      language: github_repo.language.downcase,
      clone_url: github_repo.clone_url,
      ssh_url: github_repo.ssh_url
    )
  end

  def schedule_background_jobs(repository)
    return if Rails.env.test?

    check = repository.checks.create!(commit_id: 'pending', passed: false, aasm_state: 'created')
    RepositoryCheckJob.perform_later(check.id)
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
