# frozen_string_literal: true

class GithubClient
  def initialize(token = nil)
    @token = token
    @client = Octokit::Client.new(access_token: token, auto_paginate: true) if token
  end

  def repos
    @client.repos
  end

  def repo(full_name)
    @client.repository(full_name)
  end

  def create_hook(repo_full_name, config, events)
    @client.create_hook(repo_full_name, "web", config, { events: events, active: true })
  end
end
