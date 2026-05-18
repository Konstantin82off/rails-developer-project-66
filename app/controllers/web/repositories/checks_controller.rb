# frozen_string_literal: true

class Web::Repositories::ChecksController < Web::ApplicationController
  def show
    authenticate_user!
    @repository = Repository.find(params[:repository_id])
    authorize @repository
    @check = @repository.checks.find(params[:id])
    render :show
  end

  def create
    authenticate_user!
    @repository = Repository.find(params[:repository_id])
    authorize @repository
    @check = @repository.checks.create!(commit_id: 'pending', passed: false)
    RepositoryCheckJob.perform_later(@check.id)
    redirect_to repository_check_path(@repository, @check), notice: t('flash.check_created')
  end
end
