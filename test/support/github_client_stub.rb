# frozen_string_literal: true

class GithubClientStub
  def repos
    [
      OpenStruct.new(
        id: 123,
        name: "test-repo",
        full_name: "testuser/test-repo",
        language: "Ruby",
        clone_url: "https://github.com/testuser/test-repo.git",
        ssh_url: "git@github.com:testuser/test-repo.git"
      ),
      OpenStruct.new(
        id: 456,
        name: "js-repo",
        full_name: "testuser/js-repo",
        language: "JavaScript",
        clone_url: "https://github.com/testuser/js-repo.git",
        ssh_url: "git@github.com:testuser/js-repo.git"
      )
    ]
  end

  def repo(id)
    repos.find { |r| r.id == id.to_i }
  end

  def create_hook(*)
    OpenStruct.new(id: 12_345_678, active: true)
  end
end
