require "test_helper"

class RepositoryCheckJobTest < ActiveJob::TestCase
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
    @check = @repository.checks.create!(commit_id: "pending")
  end

  test "should perform check" do
    assert_nothing_raised do
      RepositoryCheckJob.perform_now(@check.id)
    end
  end
end
