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
      )
    ]
  end

  def repo(id)
    # Для строк с буквами и для ID = 0 возвращаем nil
    return nil unless id.is_a?(Integer) || id.to_s.match?(/^\d+$/)

    id_int = id.to_i
    return nil if id_int == 0

    # Ищем существующий репозиторий
    existing = repos.find { |r| r.id == id_int }
    return existing if existing

    # Для любого числового ID > 0, которого нет в списке, возвращаем динамический репозиторий
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
