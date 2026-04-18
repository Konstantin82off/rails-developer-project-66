require "test_helper"

class CheckMailerTest < ActionMailer::TestCase
  setup do
    @user = User.create!(
      uid: "12345",
      nickname: "testuser",
      email: "test@example.com",
      token: "fake_token"
    )

    @repository = @user.repositories.create!(
      name: "test-repo",
      github_id: 123,
      full_name: "testuser/test-repo",
      language: "ruby",
      clone_url: "https://github.com/testuser/test-repo.git",
      ssh_url: "git@github.com:testuser/test-repo.git"
    )

    @check = @repository.checks.create!(
      commit_id: "abc123",
      aasm_state: "finished",
      passed: false,
      output: "Some errors found"
    )
  end

  test "failure_report" do
    mail = CheckMailer.failure_report(@check.id)

    assert_equal "Check failed for testuser/test-repo", mail.subject
    assert_equal [ @user.email ], mail.to
    assert_match /Some errors found/, mail.body.encoded
  end
end
