class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  helper_method :login_path, :current_user

  def login_path
    "/auth/github"
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end
end
