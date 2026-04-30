# frozen_string_literal: true

require "test_helper"

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      uid: "12345",
      nickname: "testuser",
      email: "test@example.com",
      token: "fake_token"
    )

    @user.repositories.destroy_all

    # Заглушка для GET /user/repos (вызывается в new action)
    stub_request(:get, "https://api.github.com/user/repos?per_page=100")
      .to_return(
        status: 200,
        body: [
          { id: 123, name: "test-repo", full_name: "testuser/test-repo", language: "Ruby" },
          { id: 345, name: "hexlet-cv", full_name: "Hexlet/hexlet-cv", language: "Ruby" },
          { id: 456, name: "js-repo", full_name: "testuser/js-repo", language: "JavaScript" },
          { id: 789, name: "py-repo", full_name: "testuser/py-repo", language: "Python" }
        ].to_json,
        headers: { "Content-Type" => "application/json" }
      )

    # Заглушка для GET /repositories/:id (вызывается в create action)
    stub_request(:get, %r{https://api.github.com/repositories/(\d+)})
      .to_return do |request|
        id = request.uri.path.split("/").last.to_i
        language = [ 123, 345 ].include?(id) ? "Ruby" : (id == 456 ? "JavaScript" : "Python")
        body = {
          id: id,
          name: id == 123 ? "test-repo" : "repo-#{id}",
          full_name: id == 123 ? "testuser/test-repo" : "user/repo-#{id}",
          language: language,
          clone_url: "https://github.com/user/repo-#{id}.git",
          ssh_url: "git@github.com:user/repo-#{id}.git"
        }
        { status: 200, body: body.to_json, headers: { "Content-Type" => "application/json" } }
      end

    post login_as_user_path, params: { user_id: @user.id }
  end

  test "should get index" do
    get repositories_path
    assert_response :success
  end

  test "should get new" do
    get new_repository_path
    assert_response :success
  end

  test "should create ruby repository" do
    assert_difference("@user.repositories.count", 1) do
      post repositories_path, params: { repository: { github_id: "123" } }
    end

    assert_redirected_to repositories_path
    assert_match(/successfully added/, flash[:notice])
  end

  test "should create javascript repository" do
    assert_difference("@user.repositories.count", 1) do
      post repositories_path, params: { repository: { github_id: "456" } }
    end

    assert_redirected_to repositories_path
    assert_match(/successfully added/, flash[:notice])
  end

  test "should not create unsupported language repository" do
    assert_no_difference("@user.repositories.count") do
      post repositories_path, params: { repository: { github_id: "789" } }
    end

    assert_redirected_to new_repository_path
    assert_match(/not supported/, flash[:alert])
  end

  test "should redirect to root if not logged in" do
    delete logout_path

    get repositories_path
    assert_redirected_to root_path
    assert_equal "Please login first", flash[:alert]
  end
end
