require "test_helper"

module Api
  class WebhooksControllerTest < ActionDispatch::IntegrationTest
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

    test "POST /api/checks should create check and return repository info" do
      payload = {
        repository: {
          full_name: @repository.full_name
        },
        after: "abc123"
      }.to_json

      assert_difference("Repository::Check.count", 1) do
        post api_checks_path, params: payload, headers: { "Content-Type" => "application/json" }
      end

      assert_response :success
      json_response = JSON.parse(response.body)
      assert_equal @repository.id, json_response["id"]
      assert_equal @repository.full_name, json_response["full_name"]
    end

    test "POST /api/checks should return not_found for unknown repository" do
      payload = {
        repository: {
          full_name: "unknown/repo"
        },
        after: "abc123"
      }.to_json

      post api_checks_path, params: payload, headers: { "Content-Type" => "application/json" }

      assert_response :not_found
    end
  end
end
