# frozen_string_literal: true

# rubocop:disable Naming/PredicateMethod
class GitStub
  def self.clone_repository(_url, _path)
    true
  end
end
# rubocop:enable Naming/PredicateMethod
