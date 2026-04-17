# frozen_string_literal: true

require "open3"
require "json"

class JavascriptLinter
  def self.run(repo_path)
    # Запускаем ESLint с JSON форматтером, используя наш конфиг
    command = "npx eslint --format json --no-eslintrc --config #{Rails.root.join('.eslintrc.js')} ."

    stdout, stderr, status = Open3.capture3(command, chdir: repo_path)

    if stdout.present?
      begin
        results = JSON.parse(stdout)
        offenses_count = results.sum { |file| file["messages"].size }
        passed = offenses_count == 0 && status.exitstatus == 0

        output = format_output(results)
      rescue JSON::ParserError
        passed = false
        output = stdout + stderr
      end
    else
      passed = status.exitstatus == 0
      output = stderr.presence || "No offenses detected"
    end

    {
      passed: passed,
      output: output,
      exit_status: status.exitstatus
    }
  rescue Errno::ENOENT
    {
      passed: false,
      output: "ESLint not found. Please run 'yarn add eslint --dev'",
      exit_status: 1
    }
  end

  def self.format_output(results)
    output = ""
    results.each do |file|
      next if file["messages"].empty?
      output += "\n#{file['filePath']}:\n"
      file["messages"].each do |message|
        output += "  Line #{message['line']}: #{message['message']} (#{message['ruleId']})\n"
      end
    end
    output
  end
end
