# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  def index
    set_default_format
    return redirect_to root_path, alert: t("flash.please_login") unless current_user
    @repositories = current_user.repositories
    render :index
  end

  def show
    set_default_format
    return redirect_to root_path, alert: t("flash.please_login") unless current_user
    @repository = current_user.repositories.find(params[:id])
    render :show
  end

  def new
    set_default_format
    return redirect_to root_path, alert: t("flash.please_login") unless current_user
    @github_repos = fetch_user_repositories
    @repositories = current_user.repositories
    render :new
  end

  def create
    set_default_format
    return redirect_to root_path, alert: t("flash.please_login") unless current_user

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

    if github_repo.language&.downcase != "ruby"
      redirect_to new_repository_path, alert: t("flash.repository_not_ruby")
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
    redirect_to repositories_path, notice: t("flash.repository_added", name: repository.name)
  end

  private

  def fetch_user_repositories
    client = ApplicationContainer[:github_client]
    client = client.call if client.is_a?(Proc)
    client.repos
  rescue StandardError => e
    Rails.logger.error "GitHub API error: #{e.message}"
    []
  end

  def fetch_repository_by_id(github_id)
    client = ApplicationContainer[:github_client]
    client = client.call if client.is_a?(Proc)
    client.repo(github_id)
  rescue StandardError => e
    Rails.logger.error "GitHub API error: #{e.message}"
    nil
  end

  def set_default_format
    request.format = :html
  end
end
