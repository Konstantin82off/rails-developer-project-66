# frozen_string_literal: true

require "ostruct"
require "json"

class GithubClientStub
  def repos
    fixture_path = Rails.root.join("test/fixtures/files/user_repositories.json")
    content = File.read(fixture_path)
    repositories = JSON.parse(content, symbolize_names: true)
    repositories.map { |repo| OpenStruct.new(repo) }
  end

  def repo(id)
    repos.find { |r| r.id == id.to_i }
  end

  def create_hook(*)
    OpenStruct.new(id: 12_345_678, active: true)
  end
end
