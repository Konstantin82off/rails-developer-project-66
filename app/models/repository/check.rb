# frozen_string_literal: true

class Repository::Check < ApplicationRecord
  include AASM

  belongs_to :repository

  validates :commit_id, presence: true

  aasm column: :aasm_state do
    state :created, initial: true
    state :cloning
    state :checking
    state :finished
    state :failed

    event :start_clone do
      transitions from: :created, to: :cloning
    end

    event :complete_clone do
      transitions from: :cloning, to: :checking
    end

    event :complete_check do
      transitions from: :checking, to: :finished
    end

    event :fail do
      transitions from: %i[cloning checking], to: :failed
    end
  end
end
