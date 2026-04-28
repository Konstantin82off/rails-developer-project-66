class AddUniqueIndexToRepositories < ActiveRecord::Migration[8.0]
  def change
    add_index :repositories, [ :github_id, :user_id ], unique: true
  end
end
