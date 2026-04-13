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

    # Создаём мок репозитория
    @mock_repo = Struct.new(:id, :name, :full_name, :language, :clone_url, :ssh_url).new(
      123,
      "test-repo",
      "testuser/test-repo",
      "Ruby",
      "https://github.com/testuser/test-repo.git",
      "git@github.com:testuser/test-repo.git"
    )
  end

  test "should get index" do
    post login_as_user_path, params: { user_id: @user.id }

    get repositories_path
    assert_response :success
  end

  test "should get new" do
    post login_as_user_path, params: { user_id: @user.id }
    Octokit::Client.any_instance.stubs(:repos).returns([ @mock_repo ])

    get new_repository_path
    assert_response :success
  end

  test "should create repository" do
    post login_as_user_path, params: { user_id: @user.id }
    Octokit::Client.any_instance.stubs(:repos).returns([ @mock_repo ])

    assert_difference("Repository.count", 1) do
      post repositories_path, params: { repository: { github_id: "123" } }
    end

    assert_redirected_to repositories_path
    assert_equal "Repository test-repo was successfully added.", flash[:notice]
  end

  test "should not create non-ruby repository" do
    post login_as_user_path, params: { user_id: @user.id }

    non_ruby_repo = Struct.new(:id, :name, :full_name, :language, :clone_url, :ssh_url).new(
      456,
      "js-repo",
      "testuser/js-repo",
      "JavaScript",
      "https://github.com/testuser/js-repo.git",
      "git@github.com:testuser/js-repo.git"
    )

    Octokit::Client.any_instance.stubs(:repos).returns([ non_ruby_repo ])

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
