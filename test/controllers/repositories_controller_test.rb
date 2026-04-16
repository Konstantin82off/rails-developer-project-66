require "test_helper"

class RepositoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Создаём тестового пользователя
    @user = User.create!(
      uid: "12345",
      nickname: "testuser",
      email: "test@example.com",
      token: "fake_token"
    )

    # Stub GitHub API calls
    stub_request(:get, /api.github.com\/user\/repos/).to_return(
      status: 200,
      body: [
        {
          id: 123,
          name: "test-repo",
          full_name: "testuser/test-repo",
          language: "Ruby",
          clone_url: "https://github.com/testuser/test-repo.git",
          ssh_url: "git@github.com:testuser/test-repo.git"
        }
      ].to_json,
      headers: { "Content-Type" => "application/json" }
    )
  end

  test "should get index" do
    post login_as_user_path, params: { user_id: @user.id }

    get repositories_path
    assert_response :success
  end

  test "should get new" do
    post login_as_user_path, params: { user_id: @user.id }

    get new_repository_path
    assert_response :success
  end

  test "should create repository" do
    post login_as_user_path, params: { user_id: @user.id }

    assert_difference("Repository.count", 1) do
      post repositories_path, params: { repository: { github_id: "123" } }
    end

    assert_redirected_to repositories_path
    assert_equal "Repository test-repo was successfully added.", flash[:notice]
  end

  test "should not create non-ruby repository" do
    post login_as_user_path, params: { user_id: @user.id }

    # Stub for non-ruby repository
    stub_request(:get, /api.github.com\/user\/repos/).to_return(
      status: 200,
      body: [
        {
          id: 456,
          name: "js-repo",
          full_name: "testuser/js-repo",
          language: "JavaScript",
          clone_url: "https://github.com/testuser/js-repo.git",
          ssh_url: "git@github.com:testuser/js-repo.git"
        }
      ].to_json,
      headers: { "Content-Type" => "application/json" }
    )

    assert_no_difference("Repository.count") do
      post repositories_path, params: { repository: { github_id: "456" } }
    end

    assert_redirected_to new_repository_path
    assert_equal "Repository is not a Ruby project or does not exist.", flash[:alert]
  end

  test "should redirect to root if not logged in" do
    get repositories_path
    assert_redirected_to root_path
    assert_equal "Please login first", flash[:alert]
  end
end
