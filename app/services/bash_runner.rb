# frozen_string_literal: true

require 'open3'

class BashRunner
  def self.execute(command)
    stdout, stderr, status = Open3.capture3(command)
    [stdout.presence || stderr, status.exitstatus]
  end
end
