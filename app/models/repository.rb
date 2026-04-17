class Repository < ApplicationRecord
  extend Enumerize

  belongs_to :user
  has_many :checks, class_name: "Repository::Check", dependent: :destroy

  validates :name, presence: true
  validates :github_id, presence: true, uniqueness: true
  validates :full_name, presence: true, uniqueness: true
  validates :clone_url, presence: true
  validates :ssh_url, presence: true

  enumerize :language, in: [ :ruby, :javascript ], predicates: true, default: :ruby

  scope :by_user, ->(user) { where(user: user) }

  # Временная заглушка для checks (будет заменена на реальную ассоциацию)
  def checks
    super
  end
end
