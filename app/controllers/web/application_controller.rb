# frozen_string_literal: true

class Web::ApplicationController < ApplicationController
  include Pundit::Authorization

  allow_browser versions: :modern

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def authenticate_user!
    return if current_user

    redirect_to root_path, alert: t('flash.please_login')
  end

  def user_not_authorized
    redirect_to root_path, alert: t('flash.not_authorized')
  end
end
