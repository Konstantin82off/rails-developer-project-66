# frozen_string_literal: true
 
class ChangeGithubIdToBigint < ActiveRecord::Migration[8.0]
  def change
    change_column :repositories, :github_id, :bigint
  end
end