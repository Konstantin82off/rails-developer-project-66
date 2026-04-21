ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "mocha/minitest"
require "webmock/minitest"

WebMock.disable_net_connect!(allow_localhost: true)

class ActionDispatch::IntegrationTest
  setup do
    User.find_or_create_by!(email: "one@test.io")
  end
end

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)
    fixtures :all
  end
end
