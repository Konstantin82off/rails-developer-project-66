### Hexlet tests and linter status:
[![Actions Status](https://github.com/Konstantin82off/rails-developer-project-66/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/Konstantin82off/rails-developer-project-66/actions)

### CI status:
[![CI](https://github.com/Konstantin82off/rails-developer-project-66/actions/workflows/ci.yml/badge.svg)](https://github.com/Konstantin82off/rails-developer-project-66/actions/workflows/ci.yml)

# GitHub Quality Analyzer
Автоматический анализатор качества репозиториев на GitHub

## О проекте
Сервис, где разработчики могут запустить проверки кода в своих репозиториях и получить отчёт о состоянии кодовой базы, текущие ошибки.

## Требования
- Ruby 4.0.2
- Rails 8.0.4
- SQLite3

## Локальный запуск
```bash
bundle install
rails db:create db:migrate
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

## Деплой
[Открыть приложение на Render](https://rails-developer-project-66.onrender.com)
