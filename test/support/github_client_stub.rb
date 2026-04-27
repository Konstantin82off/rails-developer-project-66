# frozen_string_literal: true

RepositoryInfo = Struct.new(:id, :full_name, :name, :language, :clone_url, :ssh_url)
HookInfo = Struct.new(:id, :active)

class GithubClientStub
  def repos
    [
      RepositoryInfo.new(
        123,
        'Hexlet/hexlet-basics',
        'hexlet-basics',
        'javascript',
        'https://github.com/Hexlet/hexlet-basics.git',
        'git@github.com:Hexlet/hexlet-basics.git'
      ),
      RepositoryInfo.new(
        345,
        'Hexlet/hexlet-cv',
        'hexlet-cv',
        'ruby',
        'https://github.com/Hexlet/hexlet-cv.git',
        'git@github.com:Hexlet/hexlet-cv.git'
      )
    ]
  end

  def repo(id)
    repos.find { |r| r.id == id.to_i }
  end

  def create_hook(*)
    HookInfo.new(12_345_678, true)
  end
end
