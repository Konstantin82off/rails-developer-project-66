class User < ApplicationRecord
  has_many :repositories, dependent: :destroy

  validates :email, presence: true
  validates :nickname, presence: true
  validates :token, presence: true
  validates :uid, presence: true, uniqueness: true
end
