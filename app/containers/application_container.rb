# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :github_client, -> { GithubClientStub.new }
    register :linter_ruby, -> { LinterStub.new }
    register :linter_javascript, -> { LinterStub.new }
  else
    register :github_client, ->(token) { Octokit::Client.new(access_token: token, auto_paginate: true) }
    register :linter_ruby, -> { RubocopLinter.new }
    register :linter_javascript, -> { JavascriptLinter.new }
  end
end
