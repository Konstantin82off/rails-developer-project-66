require "test_helper"

class Repository::CheckTest < ActiveSupport::TestCase
  setup do
    @check = repository_checks(:one)
  end

  test "should be valid" do
    assert @check.valid?
  end

  test "should have commit_id" do
    @check.commit_id = nil
    assert_not @check.valid?
  end
end
