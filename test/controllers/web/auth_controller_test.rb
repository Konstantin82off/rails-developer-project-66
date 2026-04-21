require "test_helper"

module Web
  class AuthControllerTest < ActionDispatch::IntegrationTest
    setup do
      stub_request(:post, "https://github.com/login/oauth/access_token")
        .to_return(status: 200, body: "", headers: {})

      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:github] = nil
    end

    teardown do
      OmniAuth.config.test_mode = false
    end

    test "should handle auth failure" do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials
      get callback_auth_path
      # OmniAuth сам перенаправляет на /auth/failure
      assert_response :redirect
      assert_match "/auth/failure", response.redirect_url
    end

    test "should logout" do
      delete logout_path
      assert_redirected_to root_path
      assert_equal "Logged out successfully", flash[:notice]
    end

    test "should login as user" do
      user = User.create!(
        uid: "12345",
        nickname: "testuser",
        email: "test@example.com",
        token: "fake_token"
      )
      post login_as_user_path, params: { user_id: user.id }
      assert_response :success
    end
  end
end
