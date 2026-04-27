# frozen_string_literal: true

class LinterStub
  def run(repo_path)
    {
      passed: true,
      output: "Stub linter passed",
      exit_status: 0
    }
  end
end
