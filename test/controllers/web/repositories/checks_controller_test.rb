# frozen_string_literal: true

require 'test_helper'

module Web
  module Repositories
    class ChecksControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user = users(:one)
        @repository = repositories(:without_checks)
        sign_in(@user)
      end

      test 'should create check' do
        post repository_checks_path(@repository)

        assert_response :redirect
        assert_redirected_to repository_check_path(@repository, Repository::Check.last)

        check = Repository::Check.find_by(repository_id: @repository.id, commit_id: 'pending')
        assert check
        assert_includes %w[created checking finished failed], check.aasm_state
      end

      test 'should show check' do
        check = @repository.checks.create!(commit_id: 'pending')
        get repository_check_path(@repository, check)

        assert_response :success
        assert_match(/#{check.id}/, response.body)
      end
    end
  end
end
