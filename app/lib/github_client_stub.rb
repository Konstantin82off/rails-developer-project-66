# frozen_string_literal: true

require 'json'

class GithubClientStub
  HookData = Struct.new(:id, :active)

  def repos
    fixture_path = Rails.root.join('test/fixtures/files/user_repositories.json')
    content = File.read(fixture_path)
    repositories = JSON.parse(content, symbolize_names: true)
    repositories.map { |repo| GithubRepositoryStub.new(repo) }
  end

  def repo(id)
    id_int = id.to_i
    existing = repos.find { |r| r.id == id_int }
    return existing if existing

    # Определяем язык для несуществующих ID (для тестов)
    language = case id_int
               when 456
                 'JavaScript'
               when 789
                 'Python'
               else
                 'Ruby'
               end

    GithubRepositoryStub.new(
      id: id_int,
      name: "repo-#{id_int}",
      full_name: "user/repo-#{id_int}",
      language: language,
      clone_url: "https://github.com/user/repo-#{id_int}.git",
      ssh_url: "git@github.com:user/repo-#{id_int}.git"
    )
  end

  alias repository repo

  def create_hook(*)
    HookData.new(12_345_678, true)
  end
end
