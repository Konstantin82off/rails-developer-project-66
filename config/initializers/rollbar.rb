# frozen_string_literal: true

# config/initializers/rollbar.rb

Rollbar.configure do |config|
  # Безопасно берём токен из переменной окружения
  config.access_token = ENV.fetch('ROLLBAR_ACCESS_TOKEN', nil)

  # Устанавливаем окружение из Rails
  config.environment = ENV['ROLLBAR_ENV'].presence || Rails.env

  # Версия кода (опционально)
  config.code_version = ENV.fetch('GIT_SHA', nil)

  # Игнорируем некоторые исключения (не засоряют отчёты)
  config.exception_level_filters.merge!(
    'ActionController::RoutingError' => 'ignore',
    'ActiveRecord::RecordNotFound' => 'ignore'
  )

  # Включаем асинхронную отправку (рекомендуется)
  config.use_async = true

  # Для разработки и тестов отключаем отправку
  if Rails.env.local?
    config.enabled = false
  end
end
