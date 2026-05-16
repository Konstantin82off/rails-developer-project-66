# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  belongs_to :user
  has_many :checks, dependent: :destroy

  enumerize :language, in: %i[ruby javascript], default: :ruby

  validates :github_id, presence: true, uniqueness: { scope: :user_id, message: :already_added }
  validates :language, presence: true
  validates :name, :full_name, :clone_url, :ssh_url, presence: true, allow_nil: true

  validate :language_must_be_supported, on: :create

  private

  def language_must_be_supported
    # Получаем данные из GitHub через заглушку (в тестах) или реальный API
    repo_data = fetch_repo_data

    if repo_data.blank?
      errors.add(:base, :repository_not_found)
      return
    end

    language = repo_data[:language]&.downcase

    return if %w[ruby javascript].include?(language)

    errors.add(:language, :unsupported, message: "Language '#{language}' is not supported")
  end

  def fetch_repo_data
    client_class = ApplicationContainer[:github_client]
    client = client_class.new

    # Для тестов: client.repository вернёт объект с нужными методами
    repo = client.repository(github_id)

    {
      language: repo.language,
      name: repo.name,
      full_name: repo.full_name,
      clone_url: repo.clone_url,
      ssh_url: repo.ssh_url
    }
  rescue StandardError => e
    Rails.logger.error "Failed to fetch repository data: #{e.message}"
    nil
  end
end
