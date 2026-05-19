# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  SUPPORTED_LANGUAGES = %w[ruby javascript].freeze

  belongs_to :user
  has_many :checks, dependent: :destroy

  enumerize :language, in: SUPPORTED_LANGUAGES

  validates :github_id, presence: true, uniqueness: { scope: :user_id, message: :already_added }
end
