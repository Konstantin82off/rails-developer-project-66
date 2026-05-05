# frozen_string_literal: true

class AddUniqueIndexToRepositories < ActiveRecord::Migration[8.0]
  def change
    add_index :repositories, %i[github_id user_id], unique: true
  end
end
