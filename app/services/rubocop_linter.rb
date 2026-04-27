# frozen_string_literal: true

require 'open3'

class RubocopLinter
  def run(repo_path)
    stdout, stderr, status = Open3.capture3('rubocop', chdir: repo_path)

    {
      passed: status.exitstatus.zero?,
      output: stdout + stderr,
      exit_status: status.exitstatus
    }
  rescue Errno::ENOENT
    {
      passed: false,
      output: 'Rubocop not found',
      exit_status: 1
    }
  end
end
