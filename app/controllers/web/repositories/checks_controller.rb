# frozen_string_literal: true

module Web
  module Repositories
    class ChecksController < ApplicationController
      def create
        set_default_format
        return redirect_to root_path, alert: t("flash.please_login") unless current_user
        repository = current_user.repositories.find(params[:repository_id])
        @check = repository.checks.create!(commit_id: "pending")
        RepositoryCheckJob.perform_later(@check.id)
        redirect_to repository_check_path(repository, @check), notice: t("flash.check_created")
      end

      def show
        set_default_format
        return redirect_to root_path, alert: t("flash.please_login") unless current_user
        @repository = current_user.repositories.find(params[:repository_id])
        @check = @repository.checks.find(params[:id])
        render :show
      end
    end
  end
end
