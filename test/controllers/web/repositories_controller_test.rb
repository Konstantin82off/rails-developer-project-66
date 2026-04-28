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
