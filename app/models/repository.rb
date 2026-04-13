class Repository < ApplicationRecord
  extend Enumerize

  belongs_to :user

  validates :name, presence: true
  validates :github_id, presence: true, uniqueness: true
  validates :full_name, presence: true, uniqueness: true
  validates :clone_url, presence: true
  validates :ssh_url, presence: true

  enumerize :language, in: [ :ruby ], predicates: true, default: :ruby

  scope :by_user, ->(user) { where(user: user) }

  # Временная заглушка для checks (будет заменена на реальную ассоциацию в следующем шаге)
  def checks
    []
  end
end
