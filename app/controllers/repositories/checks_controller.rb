# frozen_string_literal: true

class Repositories::ChecksController < ApplicationController
  before_action :authenticate_user!
  before_action :load_repository

  def create
    @check = @repository.checks.create!(commit_id: "pending")

    RepositoryCheckJob.perform_later(@check.id)

    redirect_to repository_check_path(@repository, @check), notice: "Check was created and is being processed"
  end

  def show
    @check = @repository.checks.find(params[:id])
  end

  private

  def load_repository
    @repository = current_user.repositories.find(params[:repository_id])
  end
end
