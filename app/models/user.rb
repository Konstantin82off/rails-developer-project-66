class User < ApplicationRecord
  validates :email, presence: true
  validates :nickname, presence: true
  validates :token, presence: true
  validates :uid, presence: true, uniqueness: true
end
