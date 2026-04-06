### Hexlet tests and linter status:
[![Actions Status](https://github.com/Konstantin82off/rails-developer-project-66/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/Konstantin82off/rails-developer-project-66/actions)

### CI status:
[![CI](https://github.com/Konstantin82off/rails-developer-project-66/actions/workflows/ci.yml/badge.svg)](https://github.com/Konstantin82off/rails-developer-project-66/actions/workflows/ci.yml)

# GitHub Quality Analyzer

Автоматический анализатор качества репозиториев на GitHub

## О проекте

Сервис, где разработчики могут запустить проверки кода в своих репозиториях и получить отчёт о состоянии кодовой базы, текущие ошибки.

## Функциональность

- ✅ Аутентификация через GitHub OAuth
- ✅ Отслеживание ошибок через Rollbar
- ✅ Автоматические проверки кода (RuboCop)
- ✅ CI/CD через GitHub Actions

## Деплой

[Открыть приложение на Render](https://rails-developer-project-66.onrender.com)

## Используемые технологии

- Ruby 4.0.2
- Rails 8.0.5
- Bootstrap 5
- esbuild
- SQLite3 (разработка) / PostgreSQL (продакшен)
- Rollbar
- Render
- OmniAuth + GitHub OAuth

## Локальный запуск

```bash
# Установка зависимостей
bundle install

# Настройка переменных окружения
cp .env.example .env
# Заполните .env своими GITHUB_CLIENT_ID и GITHUB_CLIENT_SECRET

# Создание базы данных и миграции
rails db:create db:migrate

# Запуск сервера
rails server
```

## Запуск тестов

```bash
rails test
```

## Линтер

```bash
rubocop
```
