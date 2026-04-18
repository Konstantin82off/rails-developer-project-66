### Hexlet tests and linter status:
[![Actions Status](https://github.com/Konstantin82off/rails-developer-project-66/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/Konstantin82off/rails-developer-project-66/actions)

### CI status:
[![CI](https://github.com/Konstantin82off/rails-developer-project-66/actions/workflows/ci.yml/badge.svg)](https://github.com/Konstantin82off/rails-developer-project-66/actions/workflows/ci.yml)

# GitHub Quality Analyzer

Автоматический анализатор качества репозиториев на GitHub

## О проекте

Сервис для автоматической проверки кода в GitHub репозиториях. Поддерживает Ruby (RuboCop) и JavaScript (ESLint).

## Деплой

**[Открыть приложение на Render](https://rails-developer-project-66.onrender.com)**

## Основные возможности

- Вход через GitHub OAuth
- Добавление репозиториев (Ruby, JavaScript)
- Автоматическая проверка кода (RuboCop для Ruby, ESLint для JavaScript)
- Автоматические проверки при push через вебхуки
- Email-уведомления о результатах проверки
- Отслеживание ошибок через Rollbar

## Быстрый старт

```bash
bundle install
yarn install
rails db:create db:migrate
rails server
```

## Тесты

```bash
rails test
```

## Линтеры

```bash
rubocop              # Ruby
npx eslint .         # JavaScript
```

## API

- POST /api/checks — вебхук от GitHub
- GET /repositories — список репозиториев
- POST /repositories — добавить репозиторий
- GET /repositories/:id — детали репозитория
- POST /repositories/:repository_id/checks — запустить проверку

## Переменные окружения

Создайте файл .env:

```bash
GITHUB_CLIENT_ID=your_client_id
GITHUB_CLIENT_SECRET=your_client_secret
BASE_URL=http://localhost:3000
SMTP_ADDRESS=sandbox.smtp.mailtrap.io
SMTP_PORT=2525
SMTP_USERNAME=your_smtp_username
SMTP_PASSWORD=your_smtp_password
```

## Технологии

- Ruby 4.0.2 / Rails 8.0.5
- Bootstrap 5
- PostgreSQL / SQLite3
- Rollbar, Octokit, OmniAuth
- RuboCop, ESLint
- ActiveJob, AASM
