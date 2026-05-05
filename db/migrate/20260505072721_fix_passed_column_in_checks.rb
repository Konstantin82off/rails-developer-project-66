# frozen_string_literal: true

class FixPassedColumnInChecks < ActiveRecord::Migration[8.0]
  def up
    # Устанавливаем false для всех существующих записей
    execute('UPDATE repository_checks SET passed = false WHERE passed IS NULL')

    # Меняем default и добавляем NOT NULL
    change_column_default :repository_checks, :passed, false
    change_column_null :repository_checks, :passed, false
  end

  def down
    change_column_null :repository_checks, :passed, true
    change_column_default :repository_checks, :passed, nil
  end
end
