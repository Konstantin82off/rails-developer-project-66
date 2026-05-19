# frozen_string_literal: true

# rubocop:disable Naming/PredicateMethod
class GitStub
  def self.clone_repository(_url, _path)
    true
  end

  def self.rev_parse_short_head(_path)
    'abc1234'
  end
end
# rubocop:enable Naming/PredicateMethod
