# frozen_string_literal: true

require 'test_helper'

class CheckMailerTest < ActionMailer::TestCase
  setup do
    @user = users(:one)
    @repository = repositories(:without_checks)
    @check = @repository.checks.create!(
      commit_id: 'abc123',
      aasm_state: 'finished',
      passed: false,
      output: 'Some errors found'
    )
  end

  test 'failure_report' do
    mail = CheckMailer.failure_report(@check.id)

    assert_equal 'Check failed for Hexlet/hexlet-cv', mail.subject
    assert_equal [@user.email], mail.to
    assert_match(/Some errors found/, mail.body.encoded)
  end
end
