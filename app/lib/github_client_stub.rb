# frozen_string_literal: true

require 'json'

class GithubClientStub
  # Определяем структуры для замены OpenStruct
  RepoData = Struct.new(:id, :name, :full_name, :language, :clone_url, :ssh_url)
  HookData = Struct.new(:id, :active)

  def repos
    fixture_path = Rails.root.join('test/fixtures/files/user_repositories.json')
    content = File.read(fixture_path)
    repositories = JSON.parse(content, symbolize_names: true)
    repositories.map { |repo| RepoData.new(repo[:id], repo[:name], repo[:full_name], repo[:language], repo[:clone_url], repo[:ssh_url]) }
  end

  def repo(id)
    id_int = id.to_i
    existing = repos.find { |r| r.id == id_int }
    return existing if existing

    # Для любого несуществующего ID возвращаем репозиторий (Ruby по умолчанию)
    RepoData.new(
      id_int,
      "repo-#{id_int}",
      "user/repo-#{id_int}",
      'Ruby',
      "https://github.com/user/repo-#{id_int}.git",
      "git@github.com:user/repo-#{id_int}.git"
    )
  end

  def create_hook(*)
    HookData.new(12_345_678, true)
  end
end
