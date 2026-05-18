# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  SUPPORTED_LANGUAGES = %w[ruby javascript].freeze

  belongs_to :user
  has_many :checks, dependent: :destroy

  enumerize :language, in: SUPPORTED_LANGUAGES

  validates :github_id, presence: true, uniqueness: { scope: :user_id, message: :already_added }
  validate :language_supported, on: :create

  before_validation :fetch_github_data, on: :create

  private

  def fetch_github_data
    return if github_id.blank?

    repo_data = fetch_repo_from_github

    if repo_data
      self.name = repo_data[:name]
      self.full_name = repo_data[:full_name]
      self.language = repo_data[:language]&.downcase
      self.clone_url = repo_data[:clone_url]
      self.ssh_url = repo_data[:ssh_url]
    else
      errors.add(:github_id, :not_found)
    end
  end

  def language_supported
    return if language.blank?
    return if SUPPORTED_LANGUAGES.include?(language)

    errors.add(:language, :unsupported)
  end

  def fetch_repo_from_github
    client = github_client
    repo = client.repository(github_id)

    {
      name: repo.name,
      full_name: repo.full_name,
      language: repo.language,
      clone_url: repo.clone_url,
      ssh_url: repo.ssh_url
    }
  rescue StandardError
    nil
  end

  def github_client
    client_class = ApplicationContainer[:github_client]

    if Rails.env.test?
      client_class.new
    else
      client_class.new(access_token: user.token, auto_paginate: true)
    end
  end
end
