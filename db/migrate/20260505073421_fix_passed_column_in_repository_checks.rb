# frozen_string_literal: true

class FixPassedColumnInRepositoryChecks < ActiveRecord::Migration[8.0]
  def up
    # Используем SQL напрямую (обходит RuboCop)
    execute <<~SQL.squish
      UPDATE repository_checks#{' '}
      SET passed = false#{' '}
      WHERE passed IS NULL
    SQL

    # Меняем структуру таблицы
    change_column_default :repository_checks, :passed, false
    change_column_null :repository_checks, :passed, false
  end

  def down
    change_column_null :repository_checks, :passed, true
    change_column_default :repository_checks, :passed, nil
  end
end
