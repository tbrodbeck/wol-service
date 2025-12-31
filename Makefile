.PHONY: help test format check build run stop logs deploy-local

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

# Development
test: ## Run tests
	mix test

format: ## Format code
	mix format

check: ## Run all checks (compile, credo, format, test)
	mix compile --warnings-as-errors
	mix deps.unlock --check-unused
	mix format --check-formatted
	mix credo --strict
	mix test
	mix dialyzer

# Docker
build: ## Build Docker image locally
	docker build -t wol_service .

run: ## Run Docker container locally
	docker run --rm -p 4000:4000 \
		-e PHX_HOST=localhost \
		-e PHX_SERVER=true \
		-e SECRET_KEY_BASE=$$(mix phx.gen.secret) \
		wol_service

stop: ## Stop local Docker container
	docker stop wol_service 2>/dev/null || true

logs: ## Show Docker container logs
	docker logs -f wol_service

deploy-local: ## Deploy using docker-compose (for local testing)
	docker compose up -d

# Default
.DEFAULT_GOAL := help