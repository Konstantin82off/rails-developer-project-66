# frozen_string_literal: true

require "ostruct"

class GithubClientStub
  def initialize(**kwargs)
    @kwargs = kwargs
  end

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
        id: 345,
        name: "hexlet-cv",
        full_name: "Hexlet/hexlet-cv",
        language: "Ruby",
        clone_url: "https://github.com/Hexlet/hexlet-cv.git",
        ssh_url: "git@github.com:Hexlet/hexlet-cv.git"
      )
    ]
  end

  def repo(id)
    if id.to_s == "456"
      return OpenStruct.new(
        id: 456,
        name: "js-repo",
        full_name: "testuser/js-repo",
        language: "JavaScript",
        clone_url: "https://github.com/testuser/js-repo.git",
        ssh_url: "git@github.com:testuser/js-repo.git"
      )
    end

    repos.find { |r| r.id == id.to_i } || OpenStruct.new(
      id: id.to_i,
      name: "repo-#{id}",
      full_name: "dynamic/repo-#{id}",
      language: "Ruby",
      clone_url: "https://github.com/dynamic/repo-#{id}.git",
      ssh_url: "git@github.com:dynamic/repo-#{id}.git"
    )
  end

  def commits(repo_full_name)
    [ OpenStruct.new(sha: "abc123def456") ]
  end
end
