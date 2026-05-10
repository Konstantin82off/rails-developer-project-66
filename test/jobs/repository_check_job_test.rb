# frozen_string_literal: true

require 'test_helper'

class RepositoryCheckJobTest < ActiveJob::TestCase
  setup do
    @user = users(:one)

    # Очищаем репозитории пользователя перед каждым тестом
    @user.repositories.destroy_all

    @repository = @user.repositories.create!(
      name: 'test-repo',
      github_id: 9993,
      full_name: 'testuser/test-repo',
      language: 'ruby',
      clone_url: 'https://github.com/testuser/test-repo.git',
      ssh_url: 'git@github.com:testuser/test-repo.git'
    )
    @check = @repository.checks.create!(commit_id: 'pending')
  end

  test 'should perform check' do
    assert_nothing_raised do
      RepositoryCheckJob.perform_now(@check.id)
    end
  end
end
