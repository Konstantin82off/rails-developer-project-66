# frozen_string_literal: true

require 'test_helper'

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    post login_as_user_path, params: { user_id: @user.id }
  end

  # Очищаем репозитории пользователя перед каждым тестом
  setup do
    @user.repositories.destroy_all
  end

  test 'should get index' do
    get repositories_path
    assert_response :success
  end

  test 'should get new' do
    get new_repository_path
    assert_response :success
  end

  test 'should create repository with valid github_id' do
    assert_difference('@user.repositories.count', 1) do
      post repositories_path, params: { repository: { github_id: '345' } }
    end

    assert_redirected_to repositories_path
    assert_match(/successfully added/, flash[:notice])
  end

  test 'should not create repository with non-existent github_id' do
    assert_no_difference('@user.repositories.count') do
      post repositories_path, params: { repository: { github_id: 'non_existent_id' } }
    end

    assert_response :unprocessable_entity
    assert_equal 'Repository not found', flash[:alert]
  end

  test 'should not create duplicate repository' do
    # Сначала создаем репозиторий
    post repositories_path, params: { repository: { github_id: '345' } }

    # Пытаемся создать его же
    assert_no_difference('@user.repositories.count') do
      post repositories_path, params: { repository: { github_id: '345' } }
    end

    assert_response :unprocessable_entity
    assert_equal 'Repository already added', flash[:alert]
  end

  test 'should redirect to root if not logged in' do
    delete logout_path

    get repositories_path
    assert_redirected_to root_path
    assert_equal 'Please login first', flash[:alert]
  end
end
