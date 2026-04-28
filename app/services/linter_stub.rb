# frozen_string_literal: true

class LinterStub
  def self.run(repo_path)
    {
      passed: true,
      output: "No offenses detected",
      exit_status: 0
    }
  end
end
