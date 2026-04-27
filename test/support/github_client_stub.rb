# frozen_string_literal: true

class GithubClientStub
  def initialize(token = nil)
    @token = token
  end

  def repos
    [
      OpenStruct.new(
        id: 123,
        full_name: "Hexlet/hexlet-basics",
        name: "hexlet-basics",
        language: "javascript",
        clone_url: "https://github.com/Hexlet/hexlet-basics.git",
        ssh_url: "git@github.com:Hexlet/hexlet-basics.git"
      ),
      OpenStruct.new(
        id: 345,
        full_name: "Hexlet/hexlet-cv",
        name: "hexlet-cv",
        language: "ruby",
        clone_url: "https://github.com/Hexlet/hexlet-cv.git",
        ssh_url: "git@github.com:Hexlet/hexlet-cv.git"
      )
    ]
  end

  def repo(full_name)
    repos.find { |r| r.full_name == full_name }
  end

  def create_hook(repo_full_name, config, events)
    OpenStruct.new(id: 12345678, active: true)
  end
end
