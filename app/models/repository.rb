class Repository < ApplicationRecord
  extend Enumerize

  belongs_to :user
  has_many :checks, class_name: "Repository::Check", dependent: :destroy

  enumerize :language, in: [ :ruby, :javascript ], default: :ruby
end
