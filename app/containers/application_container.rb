# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :github_client, -> { GithubClientStub }
    register :linter, -> { LinterStub }
  else
    register :github_client, -> { Octokit::Client }
    register :linter, -> { RubocopLinter }
  end
end
