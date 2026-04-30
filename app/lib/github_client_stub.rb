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
        id: 345,
        name: "hexlet-cv",
        full_name: "Hexlet/hexlet-cv",
        language: "Ruby",
        clone_url: "https://github.com/Hexlet/hexlet-cv.git",
        ssh_url: "git@github.com:Hexlet/hexlet-cv.git"
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

    case id_int
    when 123, 345
      OpenStruct.new(
        id: id_int,
        name: id_int == 123 ? "test-repo" : "hexlet-cv",
        full_name: id_int == 123 ? "testuser/test-repo" : "Hexlet/hexlet-cv",
        language: "Ruby",
        clone_url: "https://github.com/user/repo-#{id_int}.git",
        ssh_url: "git@github.com:user/repo-#{id_int}.git"
      )
    when 456
      OpenStruct.new(
        id: 456,
        name: "js-repo",
        full_name: "testuser/js-repo",
        language: "JavaScript",
        clone_url: "https://github.com/testuser/js-repo.git",
        ssh_url: "git@github.com:testuser/js-repo.git"
      )
    when 789
      OpenStruct.new(
        id: 789,
        name: "py-repo",
        full_name: "testuser/py-repo",
        language: "Python",
        clone_url: "https://github.com/testuser/py-repo.git",
        ssh_url: "git@github.com:testuser/py-repo.git"
      )
    else
      OpenStruct.new(
        id: id_int,
        name: "repo-#{id_int}",
        full_name: "user/repo-#{id_int}",
        language: "Ruby",
        clone_url: "https://github.com/user/repo-#{id_int}.git",
        ssh_url: "git@github.com:user/repo-#{id_int}.git"
      )
    end
  end

  def create_hook(*)
    OpenStruct.new(id: 12_345_678, active: true)
  end
end
