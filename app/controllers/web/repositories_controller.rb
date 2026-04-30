# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  before_action :authenticate_user!, except: [ :show ]

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
    @github_repos = fetch_user_repositories
    @repositories = current_user.repositories
    render :new
  end

  def create
    set_default_format

    github_id = params[:repository][:github_id]

    if github_id.blank?
      flash[:alert] = t(".github_cannot_be_blank")
      redirect_to new_repository_path
      return
    end

    github_repo = fetch_repository_by_id(github_id)

    if github_repo.nil?
      redirect_to new_repository_path, alert: t("flash.repository_not_found")
      return
    end

    unless github_repo.language&.downcase == "ruby" || github_repo.language&.downcase == "javascript"
      redirect_to new_repository_path, alert: t("flash.repository_not_supported")
      return
    end

    if current_user.repositories.exists?(github_id: github_repo.id)
      redirect_to new_repository_path, alert: t("flash.repository_already_added")
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

    redirect_to repositories_path, notice: t("flash.repository_added", name: repository.name)
  end

  private

  def authenticate_user!
    return if current_user
    redirect_to root_path, alert: t("flash.please_login")
  end

  def github_client
    client_class = ApplicationContainer[:github_client]

    if Rails.env.test?
      client_class.new
    else
      client_class.new(access_token: current_user.token, auto_paginate: true)
    end
  end

  def fetch_user_repositories
    existing_ids = current_user.repositories.pluck(:github_id)
    github_client.repos.reject { |r| existing_ids.include?(r.id) }
  rescue StandardError => e
    Rails.logger.error "GitHub API error: #{e.message}"
    []
  end

  def fetch_repository_by_id(github_id)
    if Rails.env.test?
      github_client.repo(github_id)
    else
      github_client.repository(github_id.to_i)
    end
  rescue StandardError => e
    Rails.logger.error "GitHub API error: #{e.message}"
    nil
  end

  def create_webhook(repository)
    return if Rails.env.test?

    webhook_url = Rails.application.routes.url_helpers.api_checks_url(host: ENV.fetch("BASE_URL", "localhost:3000"))
    client = github_client
    client.create_hook(
      repository.full_name,
      "web",
      { url: webhook_url, content_type: "json" },
      { events: [ "push" ], active: true }
    )
  rescue StandardError => e
    Rails.logger.error "Failed to create webhook for #{repository.full_name}: #{e.message}"
  end

  def set_default_format
    request.format = :html
  end
end
