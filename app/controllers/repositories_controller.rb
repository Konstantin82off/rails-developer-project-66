class RepositoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @repositories = current_user.repositories
  end

  def show
    @repository = current_user.repositories.find(params[:id])
  end

  def new
    @github_repos = fetch_user_repositories
    @repositories = current_user.repositories
  end

  def create
    repo_params = params.require(:repository).permit(:github_id)
    github_repo = fetch_user_repositories.find { |r| r.id.to_s == repo_params[:github_id] }

    if github_repo && github_repo.language&.downcase == "ruby"
      repository = current_user.repositories.create!(
        name: github_repo.name,
        github_id: github_repo.id,
        full_name: github_repo.full_name,
        language: github_repo.language.downcase,
        clone_url: github_repo.clone_url,
        ssh_url: github_repo.ssh_url
      )
      redirect_to repositories_path, notice: "Repository #{repository.name} was successfully added."
    else
      redirect_to new_repository_path, alert: "Repository is not a Ruby project or does not exist."
    end
  end

  private

  def authenticate_user!
    redirect_to root_path, alert: "Please login first" unless session[:user_id]
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def fetch_user_repositories
    client = Octokit::Client.new(access_token: current_user.token, auto_paginate: true)
    client.repos
  rescue Octokit::Error => e
    Rails.logger.error "GitHub API error: #{e.message}"
    []
  end
end
