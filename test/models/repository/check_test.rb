# frozen_string_literal: true

require 'test_helper'

class Repository::CheckTest < ActiveSupport::TestCase
  setup do
    @check = repository_checks(:one)
  end

  test 'should be valid' do
    assert @check.valid?
  end
end
