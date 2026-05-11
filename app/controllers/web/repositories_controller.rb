# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  before_action :authenticate_user!

  def index
    set_default_format
    @repositories = current_user.repositories
    render :index
  end

  def show
    set_default_format
    @repository = current_user.repositories.find(params[:id])
    render :show
  end

  def new
    set_default_format
    @github_repos = github_service.fetch_user_repositories(exclude_ids: current_user.repositories.pluck(:github_id))
    @repositories = current_user.repositories
    render :new
  end

  def create
    set_default_format

    github_id = params[:repository][:github_id]

    if github_id.blank?
      flash[:alert] = t('.github_cannot_be_blank')
      redirect_to new_repository_path
      return
    end

    github_repo = github_service.fetch_repository_by_id(github_id)

    if github_repo.nil?
      redirect_to new_repository_path, alert: t('flash.repository_not_found')
      return
    end

    unless %w[ruby javascript].include?(github_repo.language&.downcase)
      redirect_to new_repository_path, alert: t('flash.repository_not_supported')
      return
    end

    if current_user.repositories.exists?(github_id: github_repo.id)
      redirect_to new_repository_path, alert: t('flash.repository_already_added')
      return
    end

    # Создаём репозиторий только с обязательными полями
    repository = current_user.repositories.create!(
      github_id: github_repo.id,
      language: github_repo.language.downcase
    )

    # Запускаем фоновую джобу для заполнения остальных полей и создания вебхука
    UpdateRepositoryInfoJob.perform_later(repository.id)

    # Автоматическая проверка при создании репозитория
    unless Rails.env.test?
      check = repository.checks.create!(commit_id: 'pending', passed: false)
      RepositoryCheckJob.perform_now(check.id)
    end

    redirect_to repositories_path, notice: t('flash.repository_added', name: repository.github_id)
  end

  private

  def authenticate_user!
    return if current_user

    redirect_to root_path, alert: t('flash.please_login')
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

  def set_default_format
    request.format = :html
  end
end
