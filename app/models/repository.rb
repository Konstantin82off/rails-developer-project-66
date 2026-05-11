# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  belongs_to :user
  has_many :checks, dependent: :destroy

  enumerize :language, in: %i[ruby javascript], default: :ruby

  validates :github_id, presence: true, uniqueness: { scope: :user_id, message: :already_added }
  validates :language, presence: true
  # name, full_name, clone_url, ssh_url могут быть nil до обновления джобой
end
