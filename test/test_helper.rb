ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "mocha/minitest"
require "webmock/minitest"

WebMock.disable_net_connect!(allow_localhost: true)

class ActionDispatch::IntegrationTest
  # Переопределяем метод get для всех тестов
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
