# frozen_string_literal: true

require 'test_helper'

module Web
  module Repositories
    class ChecksControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user = users(:one)

        @user.repositories.destroy_all

        @repository = @user.repositories.create!(
          name: 'test-repo',
          github_id: 9992,
          full_name: 'testuser/test-repo',
          language: 'ruby',
          clone_url: 'https://github.com/testuser/test-repo.git',
          ssh_url: 'git@github.com:testuser/test-repo.git'
        )

        sign_in(@user)
      end

      test 'should create check' do
        post repository_checks_path(@repository)

        assert_response :redirect
        assert_redirected_to repository_check_path(@repository, Repository::Check.last)

        check = Repository::Check.find_by(repository_id: @repository.id, commit_id: 'pending')
        assert check
        # Проверяем финальное состояние, а не промежуточное
        assert check.finished?
      end

      test 'should show check' do
        check = @repository.checks.create!(commit_id: 'pending')
        get repository_check_path(@repository, check)

        assert_response :success
        # Проверяем, что страница содержит ID проверки (без зависимости от языка)
        assert_match(/#{check.id}/, response.body)
      end
    end
  end
end
