# frozen_string_literal: true

# rubocop:disable Style/OneClassPerFile

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'mocha/minitest'
require 'webmock/minitest'

# Configure ActiveJob for tests
ActiveJob::Base.queue_adapter = :test
ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true

OmniAuth.config.test_mode = true

WebMock.disable_net_connect!(allow_localhost: true)

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)
    fixtures :all
  end
end

class ActionDispatch::IntegrationTest
  def sign_in(user, _options = {})
    post login_as_user_path(user_id: user.id)
  end

  def signed_in?
    session[:user_id].present? && current_user.present?
  end

  def current_user
    return @current_user if defined?(@current_user)

    @current_user = User.find_by(id: session[:user_id])
  end
end

# rubocop:enable Style/OneClassPerFile
