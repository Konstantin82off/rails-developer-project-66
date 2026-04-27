# frozen_string_literal: true

RepositoryInfo = Struct.new(:id, :full_name, :name, :language, :clone_url, :ssh_url)
HookInfo = Struct.new(:id, :active)

class GithubClientStub
  def repos
    [
      RepositoryInfo.new(123, "Hexlet/hexlet-basics", "hexlet-basics", "javascript", "https://github.com/Hexlet/hexlet-basics.git", "git@github.com:Hexlet/hexlet-basics.git"),
      RepositoryInfo.new(345, "Hexlet/hexlet-cv", "hexlet-cv", "ruby", "https://github.com/Hexlet/hexlet-cv.git", "git@github.com:Hexlet/hexlet-cv.git")
    ]
  end

  def repo(id)
    id_int = id.to_i
    existing = repos.find { |r| r.id == id_int }
    return existing if existing
    RepositoryInfo.new(id_int, "user/repo-#{id_int}", "repo-#{id_int}", "ruby", "https://github.com/user/repo-#{id_int}.git", "git@github.com:user/repo-#{id_int}.git")
  end

  def create_hook(*)
    HookInfo.new(12_345_678, true)
  end
end
