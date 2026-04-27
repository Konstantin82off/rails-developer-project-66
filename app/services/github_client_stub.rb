# frozen_string_literal: true

RepositoryInfo = Struct.new(:id, :name, :full_name, :language, :clone_url, :ssh_url)

class GithubClientStub
  def repos
    [
      RepositoryInfo.new(
        123,
        'test-repo',
        'testuser/test-repo',
        'Ruby',
        'https://github.com/testuser/test-repo.git',
        'git@github.com:testuser/test-repo.git'
      ),
      RepositoryInfo.new(
        345,
        'hexlet-cv',
        'Hexlet/hexlet-cv',
        'Ruby',
        'https://github.com/Hexlet/hexlet-cv.git',
        'git@github.com:Hexlet/hexlet-cv.git'
      )
    ]
  end

  def repo(id)
    return nil unless id.is_a?(Integer) || id.to_s.match?(/^\d+$/)

    id_int = id.to_i
    return nil if id_int.zero?

    repos.find { |r| r.id == id_int }
  end
end
