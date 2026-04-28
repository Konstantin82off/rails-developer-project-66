# frozen_string_literal: true

class GithubClientStub
  def repos
    [
      OpenStruct.new(id: 123, full_name: "Hexlet/hexlet-basics", name: "hexlet-basics", language: "javascript", clone_url: "https://github.com/Hexlet/hexlet-basics.git", ssh_url: "git@github.com:Hexlet/hexlet-basics.git"),
      OpenStruct.new(id: 345, full_name: "Hexlet/hexlet-cv", name: "hexlet-cv", language: "ruby", clone_url: "https://github.com/Hexlet/hexlet-cv.git", ssh_url: "git@github.com:Hexlet/hexlet-cv.git")
    ]
  end

  def repo(id)
    id_int = id.to_i
    existing = repos.find { |r| r.id == id_int }
    return existing if existing

    OpenStruct.new(id: id_int, full_name: "user/repo-#{id_int}", name: "repo-#{id_int}", language: "ruby", clone_url: "https://github.com/user/repo-#{id_int}.git", ssh_url: "git@github.com:user/repo-#{id_int}.git")
  end

  def create_hook(*)
    OpenStruct.new(id: 12345678, active: true)
  end
end
