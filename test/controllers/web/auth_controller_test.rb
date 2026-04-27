# frozen_string_literal: true

require 'test_helper'

class Web::AuthControllerTest < ActionDispatch::IntegrationTest
  test 'check github auth' do
    post auth_request_path('github')
    assert_response :redirect
  end

  test 'create' do
    auth_hash = {
      provider: 'github',
      uid: '12345',
      info: {
        email: 'test@example.com',
        name: 'Test User'
      },
      credentials: {
        token: 'fake_token'
      }
    }

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

    get callback_auth_path('github')
    assert_response :redirect

    user = User.find_by(email: auth_hash[:info][:email].downcase)

    assert user
    assert signed_in?
  end

  test 'logout' do
    auth_hash = {
      provider: 'github',
      uid: '12345',
      info: {
        email: 'logout_test@example.com',
        name: 'Logout Test'
      },
      credentials: {
        token: 'fake_token'
      }
    }

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)
    get callback_auth_path('github')
    assert signed_in?

    delete logout_path
    assert_redirected_to root_path
    assert_not signed_in?
  end
end
