class RemoveNotNullConstraintsFromUsers < ActiveRecord::Migration[8.0]
  def change
    change_column_null :users, :nickname, true
    change_column_null :users, :token, true
    change_column_null :users, :uid, true
  end
end
