# frozen_string_literal: true

class RollbarController < ApplicationController
  def test
    Rollbar.info('Test message from Rails')
    raise 'Test exception from Rails'
  end
end
