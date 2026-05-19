# frozen_string_literal: true

class BashRunnerStub
  class << self
    def execute(command)
      if command.include?('git rev-parse --short HEAD')
        ['abc1234', 0]
      else
        ['', 0]
      end
    end
  end
end
