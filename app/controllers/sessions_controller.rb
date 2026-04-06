class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def new
    redirect_to "/auth/github"
  end

  def create
    auth_hash = request.env["omniauth.auth"]

    if auth_hash.nil?
      redirect_to root_path, alert: "Authentication failed"
      return
    end

    user = find_or_create_user(auth_hash)
    session[:user_id] = user.id

    redirect_to root_path, notice: "Successfully logged in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Logged out successfully"
  end

  private

  def find_or_create_user(auth_hash)
    user = User.find_or_initialize_by(uid: auth_hash["uid"])

    user.nickname = auth_hash["info"]["nickname"]
    user.email = auth_hash["info"]["email"]
    user.token = auth_hash["credentials"]["token"]

    user.save!
    user
  end
end
