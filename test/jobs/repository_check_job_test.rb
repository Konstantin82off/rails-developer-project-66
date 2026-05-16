# frozen_string_literal: true

require 'test_helper'

class RepositoryCheckJobTest < ActiveJob::TestCase
  setup do
    @user = users(:one)
    @repository = repositories(:without_checks)
    @check = @repository.checks.create!(commit_id: 'pending')
  end

  test 'should perform check' do
    assert_nothing_raised do
      RepositoryCheckJob.perform_now(@check.id)
    end
  end
end
