# frozen_string_literal: true

class Repository::Check < ApplicationRecord
  include AASM

  belongs_to :repository

  validates :commit_id, presence: true

  aasm column: :aasm_state do
    state :created, initial: true
    state :checking
    state :finished
    state :failed

    event :start do
      transitions from: :created, to: :checking
    end

    event :complete do
      transitions from: :checking, to: :finished
    end

    event :fail do
      transitions from: %i[created checking], to: :failed
    end
  end
end
