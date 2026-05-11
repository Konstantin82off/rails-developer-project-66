# frozen_string_literal: true

class Web::ApplicationController < ApplicationController
  include Pundit::Authorization

  allow_browser versions: :modern
  helper_method :current_user

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :authenticate_user!

  private

  def authenticate_user!
    return if current_user

    redirect_to root_path, alert: t('flash.please_login')
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def user_not_authorized
    redirect_to root_path, alert: t('flash.not_authorized')
  end
end
