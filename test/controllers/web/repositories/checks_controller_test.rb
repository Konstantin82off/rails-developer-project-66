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

        perform_enqueued_jobs

        check = Repository::Check.last
        assert_equal @repository.id, check.repository_id
        assert_includes %w[finished failed], check.aasm_state
        assert_equal 'abc1234', check.commit_id
      end

      test 'should show check' do
        check = @repository.checks.create!
        get repository_check_path(@repository, check)

        assert_response :success
        assert_match(/#{check.id}/, response.body)
      end
    end
  end
end
