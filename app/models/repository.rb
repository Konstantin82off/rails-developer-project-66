# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  belongs_to :user
  has_many :checks, class_name: 'Repository::Check', dependent: :destroy

  enumerize :language, in: %i[ruby javascript], default: :ruby

  validates :name, presence: true
  validates :github_id, presence: true
  validates :full_name, presence: true
end
