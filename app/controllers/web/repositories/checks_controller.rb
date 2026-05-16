# frozen_string_literal: true

class Web::Repositories::ChecksController < Web::ApplicationController
  before_action :authenticate_user!
  before_action :set_repository
  before_action :authorize_repository

  def show
    @check = @repository.checks.find(params[:id])
    render :show
  end

  def create
    @check = @repository.checks.create!(commit_id: 'pending', passed: false)
    RepositoryCheckJob.perform_later(@check.id)
    redirect_to repository_check_path(@repository, @check), notice: t('flash.check_created')
  end

  private

  def set_repository
    @repository = Repository.find(params[:repository_id])
  end

  def authorize_repository
    authorize @repository
  end
end
