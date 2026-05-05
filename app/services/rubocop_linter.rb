# frozen_string_literal: true

require 'open3'
require 'json'

class RubocopLinter
  def run(repo_path)
    # Отладка: проверяем наличие Ruby файлов
    ruby_files = Dir.glob("#{repo_path}/**/*.rb").count
    Rails.logger.info "=== Ruby files in #{repo_path}: #{ruby_files} ==="

    config_path = Rails.root.join('.rubocop.yml').to_s
    # Запускаем RuboCop на всей директории репозитория
    command = "cd #{repo_path} && rubocop --format json --config #{config_path} . 2>&1"

    stdout, stderr, status = Open3.capture3(command)
    output = stdout + stderr

    Rails.logger.info '=== RuboCop Debug ==='
    Rails.logger.info "Command: #{command}"
    Rails.logger.info "Exit code: #{status.exitstatus}"
    Rails.logger.info "Output is JSON: #{output.start_with?('{')}"

    # Парсим JSON для отладки
    begin
      parsed = JSON.parse(output)
      Rails.logger.info "Inspected files: #{parsed.dig('summary', 'inspected_file_count')}"
      Rails.logger.info "Offense count: #{parsed.dig('summary', 'offense_count')}"
    rescue StandardError
      Rails.logger.info 'Failed to parse JSON output'
    end

    {
      passed: status.exitstatus.zero?,
      output: output,
      exit_status: status.exitstatus
    }
  rescue Errno::ENOENT => e
    Rails.logger.error "RuboCop not found: #{e.message}"
    {
      passed: false,
      output: { error: "RuboCop not found: #{e.message}" }.to_json,
      exit_status: 1
    }
  rescue StandardError => e
    Rails.logger.error "RuboCop error: #{e.message}"
    {
      passed: false,
      output: { error: "Error running RuboCop: #{e.message}" }.to_json,
      exit_status: 1
    }
  end
end
