# frozen_string_literal: true

class GitStub
  class << self
    def clone_repository?(_clone_url, _path_to_clone)
      true
    end
  end
end
