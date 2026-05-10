# frozen_string_literal: true

require 'test_helper'

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)

    @user.repositories.destroy_all

    sign_in(@user)
  end

  test 'should get index' do
    get repositories_path
    assert_response :success
  end

  test 'should get new' do
    get new_repository_path
    assert_response :success
  end

  test 'should create ruby repository' do
    post repositories_path, params: { repository: { github_id: '123' } }

    assert_response :redirect
    assert_redirected_to repositories_path

    repository = @user.repositories.find_by(github_id: 123)
    assert repository
    assert_equal 'ruby', repository.language
    assert_equal 'test-repo', repository.name
    assert_equal 'testuser/test-repo', repository.full_name
  end

  test 'should create javascript repository' do
    post repositories_path, params: { repository: { github_id: '456' } }

    assert_response :redirect
    assert_redirected_to repositories_path

    repository = @user.repositories.find_by(github_id: 456)
    assert repository
    assert_equal 'javascript', repository.language
    assert_equal 'js-repo', repository.name
    assert_equal 'testuser/js-repo', repository.full_name
  end

  test 'should not create unsupported language repository' do
    post repositories_path, params: { repository: { github_id: '789' } }

    assert_response :redirect
    assert_redirected_to new_repository_path

    repository = @user.repositories.find_by(github_id: 789)
    assert_nil repository
  end

  test 'should redirect to root if not logged in' do
    delete logout_path

    get repositories_path
    assert_response :redirect
    assert_redirected_to root_path
  end
end
