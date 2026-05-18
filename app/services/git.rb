# frozen_string_literal: true

class Git
  def self.clone_repository(url, path)
    system("git clone #{url} #{path}")
  end
end
