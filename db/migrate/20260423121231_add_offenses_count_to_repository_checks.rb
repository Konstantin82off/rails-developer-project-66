class AddOffensesCountToRepositoryChecks < ActiveRecord::Migration[8.0]
  def change
    add_column :repository_checks, :offenses_count, :integer
  end
end
