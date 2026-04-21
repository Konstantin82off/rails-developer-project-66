require "test_helper"

module Web
  module Repositories
    class ChecksControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user = User.create!(
          uid: "12345",
          nickname: "testuser",
          email: "test@example.com",
          token: "fake_token"
        )

        @repository = @user.repositories.create!(
          name: "test-repo",
          github_id: 123,
          full_name: "testuser/test-repo",
          language: "ruby",
          clone_url: "https://github.com/testuser/test-repo.git",
          ssh_url: "git@github.com:testuser/test-repo.git"
        )
      end

      def sign_in
        post login_as_user_path, params: { user_id: @user.id }
      end

      test "should create check" do
        sign_in
        assert_difference("Repository::Check.count", 1) do
          post repository_checks_path(@repository)
        end
        assert_redirected_to repository_check_path(@repository, Repository::Check.last)
        assert_equal "Check was created and is being processed", flash[:notice]
      end

      test "should show check" do
        sign_in
        check = @repository.checks.create!(commit_id: "pending")
        get repository_check_path(@repository, check)
        assert_response :success
      end
    end
  end
end
