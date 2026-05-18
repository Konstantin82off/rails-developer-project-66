# frozen_string_literal: true

module AuthConcern
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :signed_in?
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session.delete(:user_id)
    @current_user = nil
  end

  def signed_in?
    current_user.present?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def authenticate_user!
    return if signed_in?

    redirect_to root_path, alert: t('flash.please_login')
  end
end
