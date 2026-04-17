# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :github_client, -> { GithubClientStub }
    register :linter_ruby, -> { LinterStub }
    register :linter_javascript, -> { LinterStub }
  else
    register :github_client, -> { Octokit::Client }
    register :linter_ruby, -> { RubocopLinter }
    register :linter_javascript, -> { JavascriptLinter }
  end
end
