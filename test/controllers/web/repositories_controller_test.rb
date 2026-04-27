require "test_helper"

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
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

  # Используем уникальные ID, которых нет в фикстурах
  test "should create repository with unique github_id" do
    assert_difference("Repository.count", 1) do
      post repositories_path, params: { repository: { github_id: "999" } }
    end

    assert_redirected_to repositories_path
    assert flash[:notice].present?
    assert_match(/successfully added/, flash[:notice])
  end

  test "should not create repository with invalid github_id" do
    assert_no_difference("Repository.count") do
      post repositories_path, params: { repository: { github_id: "9999999999" } }
    end

    assert_response :unprocessable_entity
    assert_equal "Repository not found", flash[:alert]
  end

  test "should not create duplicate repository" do
    # Сначала создаем репозиторий
    post repositories_path, params: { repository: { github_id: "999" } }

    # Пытаемся создать его же
    assert_no_difference("Repository.count") do
      post repositories_path, params: { repository: { github_id: "999" } }
    end

    assert_response :unprocessable_entity
    assert_equal "Repository already added", flash[:alert]
  end

  test "should redirect to root if not logged in" do
    delete logout_path

    get repositories_path
    assert_redirected_to root_path
    assert_equal "Please login first", flash[:alert]
  end
end
