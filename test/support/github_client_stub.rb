# frozen_string_literal: true

require "ostruct"

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
    id_int = id.to_i
    existing = repos.find { |r| r.id == id_int || r.id.to_s == id.to_s }
    return existing if existing

    OpenStruct.new(
      id: id_int,
      name: "repo-#{id_int}",
      full_name: "user/repo-#{id_int}",
      language: "Ruby",
      clone_url: "https://github.com/user/repo-#{id_int}.git",
      ssh_url: "git@github.com:user/repo-#{id_int}.git"
    )
  end

  def create_hook(*)
    OpenStruct.new(id: 12_345_678, active: true)
  end
end
