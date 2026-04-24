ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "mocha/minitest"
require "webmock/minitest"

WebMock.disable_net_connect!(allow_localhost: true)

class ActionDispatch::IntegrationTest
  setup do
    # Создаём пользователя для hexlet-check тестов
    User.find_or_create_by!(email: "one@test.io") do |user|
      user.nickname = "testuser"
      user.token = "fake_token"
      user.uid = "12345"
    end
  end

  def get(path, **kwargs)
    kwargs[:headers] = { "Accept" => "text/html" }.merge(kwargs[:headers] || {})
    super(path, **kwargs)
  end

  def post(path, **kwargs)
    kwargs[:headers] = { "Accept" => "text/html" }.merge(kwargs[:headers] || {})
    super(path, **kwargs)
  end
end

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)
    fixtures :all
  end
end
