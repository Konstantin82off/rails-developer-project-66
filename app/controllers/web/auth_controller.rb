# frozen_string_literal: true

class Web::AuthController < Web::ApplicationController
  def callback
    auth_hash = request.env['omniauth.auth']

    if auth_hash.nil?
      redirect_to root_path, alert: t('auth.failure')
      return
    end

    user = find_or_create_user(auth_hash)

    unless user
      redirect_to root_path, alert: t('auth.failure')
      return
    end

    sign_in(user)
    redirect_to root_path, notice: t('auth.success')
  end

  def destroy
    sign_out
    redirect_to root_path, notice: t('auth.logout_success')
  end

  def login_as_user
    user = User.find(params[:user_id])
    sign_in(user)
    head :ok
  end

  private

  def find_or_create_user(auth_hash)
    user = User.find_or_initialize_by(email: auth_hash['info']['email'].downcase)
    user.uid = auth_hash['uid']
    user.nickname = auth_hash['info']['nickname']
    user.token = auth_hash['credentials']['token']

    if user.save
      user
    else
      Rails.logger.error "Failed to save user: #{user.errors.full_messages}"
      nil
    end
  end
end
