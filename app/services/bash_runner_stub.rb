# frozen_string_literal: true

class BashRunnerStub
  class << self
    def execute(_command)
      ['', 0]
    end
  end
end
