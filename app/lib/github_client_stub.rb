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
      )
    ]
  end
end
