# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  def index
    set_default_format
    return redirect_to root_path, alert: t('flash.please_login') unless current_user

    @repositories = current_user.repositories
    render :index
  end

  def show
    set_default_format
    return redirect_to root_path, alert: t('flash.please_login') unless current_user

    @repository = current_user.repositories.find(params[:id])
    render :show
  end

  def new
    set_default_format
    return redirect_to root_path, alert: t('flash.please_login') unless current_user

    @github_repos = fetch_user_repositories
    @repositories = current_user.repositories
    render :new
  end

  def create
    set_default_format
    return redirect_to root_path, alert: t('flash.please_login') unless current_user

    github_id = params[:repository][:github_id]

    if github_id.blank?
      flash[:alert] = t('.github_cannot_be_blank')
      redirect_to new_repository_path
      return
    end

    github_repo = fetch_repository_by_id(github_id)

    if github_repo.nil?
      flash[:alert] = t('flash.repository_not_found')
      @github_repos = fetch_user_repositories
      render :new, status: :unprocessable_content
      return
    end

    if github_repo.language&.downcase != 'ruby'
      flash[:alert] = t('flash.repository_not_ruby')
      @github_repos = fetch_user_repositories
      render :new, status: :unprocessable_content
      return
    end

    if current_user.repositories.exists?(github_id: github_repo.id)
      flash[:alert] = t('flash.repository_already_added')
      @github_repos = fetch_user_repositories
      render :new, status: :unprocessable_content
      return
    end

    repository = current_user.repositories.create!(
      name: github_repo.name,
      github_id: github_repo.id,
      full_name: github_repo.full_name,
      language: github_repo.language.downcase,
      clone_url: github_repo.clone_url,
      ssh_url: github_repo.ssh_url
    )

    create_webhook(repository)

    redirect_to repositories_path, notice: t('flash.repository_added', name: repository.name)
  end

  private

  def github_client
    if Rails.env.test?
      ApplicationContainer[:github_client]
    else
      ApplicationContainer[:github_client].call(current_user.token)
    end
  end

  def fetch_user_repositories
    github_client.repos
  rescue StandardError => e
    Rails.logger.error "GitHub API error: #{e.message}"
    []
  end

  def fetch_repository_by_id(github_id)
    github_client.repo(github_id.to_i)
  rescue StandardError => e
    Rails.logger.error "GitHub API error: #{e.message}"
    nil
  end

  def create_webhook(repository)
    return if Rails.env.test?

    webhook_url = Rails.application.routes.url_helpers.api_checks_url(host: ENV.fetch('BASE_URL', 'localhost:3000'))
    client = Octokit::Client.new(access_token: current_user.token, auto_paginate: true)
    client.create_hook(
      repository.full_name,
      'web',
      { url: webhook_url, content_type: 'json' },
      { events: ['push'], active: true }
    )
  rescue Octokit::Error => e
    Rails.logger.error "Failed to create webhook for #{repository.full_name}: #{e.message}"
  end
end
