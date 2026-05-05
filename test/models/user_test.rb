# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'should have email' do
    @user.email = nil
    assert_not @user.valid?
  end
end
