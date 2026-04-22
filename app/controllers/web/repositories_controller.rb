# frozen_string_literal: true

module Web
  class RepositoriesController < ApplicationController
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

      github_repo = fetch_user_repositories.find { |r| r.id.to_s == github_id }

      if github_repo && github_repo.language&.downcase == "ruby"
        repository = current_user.repositories.create!(
          name: github_repo.name,
          github_id: github_repo.id,
          full_name: github_repo.full_name,
          language: github_repo.language.downcase,
          clone_url: github_repo.clone_url,
          ssh_url: github_repo.ssh_url
        )
        redirect_to repositories_path, notice: t("flash.repository_added", name: repository.name)
      else
        redirect_to new_repository_path, alert: t("flash.repository_not_ruby")
      end
    end

    private

    def fetch_user_repositories
      client_class = ApplicationContainer[:github_client]
      client = client_class.new(access_token: current_user.token, auto_paginate: true)
      client.repos
    rescue Octokit::Error => e
      Rails.logger.error "GitHub API error: #{e.message}"
      []
    end
  end
end
