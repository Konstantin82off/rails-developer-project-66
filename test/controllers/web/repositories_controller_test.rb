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

    # Заглушка для GET /user/repos (вызывается в new action)
    stub_request(:get, "https://api.github.com/user/repos?per_page=100")
      .to_return(
        status: 200,
        body: [
          { id: 123, name: "test-repo", full_name: "testuser/test-repo", language: "Ruby" },
          { id: 345, name: "hexlet-cv", full_name: "Hexlet/hexlet-cv", language: "Ruby" }
        ].to_json,
        headers: { "Content-Type" => "application/json" }
      )

    # Заглушка для GET /repositories/:id (вызывается в create action)
    stub_request(:get, %r{https://api.github.com/repositories/(\d+)})
      .to_return do |request|
        id = request.uri.path.split("/").last.to_i
        # Для ID 123 и 345 возвращаем Ruby репозитории
        # Для любого другого ID возвращаем JavaScript репозиторий (например 456)
        language = (id == 123 || id == 345) ? "Ruby" : "JavaScript"
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
    assert_difference("Repository.count", 1) do
      post repositories_path, params: { repository: { github_id: "123" } }
    end

    assert_redirected_to repositories_path
    assert_match(/successfully added/, flash[:notice])
  end

  test "should not create non-ruby repository" do
    # ID 456 - вернет JavaScript язык
    assert_no_difference("Repository.count") do
      post repositories_path, params: { repository: { github_id: "456" } }
    end

    assert_redirected_to new_repository_path
    assert_match(/not a Ruby project/, flash[:alert])
  end

  test "should redirect to root if not logged in" do
    delete logout_path

    get repositories_path
    assert_redirected_to root_path
    assert_equal "Please login first", flash[:alert]
  end
end
