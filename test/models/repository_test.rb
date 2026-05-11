# frozen_string_literal: true

require 'test_helper'

class RepositoryTest < ActiveSupport::TestCase
  setup do
    @repository = repositories(:without_checks)
  end

  test 'should be valid' do
    assert @repository.valid?
  end

  test 'should have github_id' do
    @repository.github_id = nil
    assert_not @repository.valid?
  end

  test 'should have language' do
    @repository.language = nil
    assert_not @repository.valid?
  end
end
