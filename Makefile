# Makefile for Rails Developer Project 66

# Colors for output
GREEN = \033[0;32m
RED = \033[0;31m
NC = \033[0m # No Color

.PHONY: help setup start test console db-prepare prepare-env

help:
	@echo "Available commands:"
	@echo "  make setup        - Setup the project (bin/setup + environment)"
	@echo "  make start        - Start the Rails server"
	@echo "  make test         - Run all tests"
	@echo "  make console      - Open Rails console"
	@echo "  make db-prepare   - Prepare database (create, migrate, seed)"
	@echo "  make prepare-env  - Copy .env.example to .env if not exists"

setup:
	@echo "$(GREEN)Setting up the project...$(NC)"
	bin/setup
	make prepare-env
	bin/rails assets:precompile
	@echo "$(GREEN)Setup complete!$(NC)"

start:
	@echo "$(GREEN)Starting Rails server...$(NC)"
	rm -f tmp/pids/server.pid || true
	bin/rails server -p 3000 -b 0.0.0.0

test:
	@echo "$(GREEN)Running tests...$(NC)"
	NODE_ENV=test bin/rails test
	@echo "$(GREEN)Tests completed!$(NC)"

console:
	@echo "$(GREEN)Opening Rails console...$(NC)"
	bin/rails console

db-prepare:
	@echo "$(GREEN)Preparing database...$(NC)"
	bin/rails db:create
	bin/rails db:migrate
	bin/rails db:seed
	@echo "$(GREEN)Database ready!$(NC)"

prepare-env:
	@echo "$(GREEN)Checking .env file...$(NC)"
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "$(GREEN).env file created from .env.example$(NC)"; \
	else \
		echo "$(GREEN).env already exists$(NC)"; \
	fi
