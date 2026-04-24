# frozen_string_literal: true

module Web
  class AuthController < ApplicationController
    def check_github_auth
      redirect_to "/auth/github"
    end

    def callback
      set_default_format
      auth_hash = request.env["omniauth.auth"]

      if auth_hash.nil?
        redirect_to root_path, alert: t("auth.failure")
        return
      end

      user = find_or_create_user(auth_hash)

      unless user
        redirect_to root_path, alert: t("auth.failure")
        return
      end

      session[:user_id] = user.id
      redirect_to root_path, notice: t("auth.success")
    end

    def destroy
      set_default_format
      session[:user_id] = nil
      redirect_to root_path, notice: t("auth.logout_success")
    end

    # Only for testing
    def login_as_user
      user = User.find(params[:user_id])
      session[:user_id] = user.id
      head :ok
    end

    private

    def find_or_create_user(auth_hash)
      user = User.find_or_initialize_by(email: auth_hash["info"]["email"])
      user.uid = auth_hash["uid"]
      user.nickname = auth_hash["info"]["nickname"]
      user.token = auth_hash["credentials"]["token"]

      if user.save
        user
      else
        Rails.logger.error "Failed to save user: #{user.errors.full_messages}"
        nil
      end
    end
  end
end
