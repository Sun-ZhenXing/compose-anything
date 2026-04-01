.PHONY: setup up down logs ps

# Download required config files from Shannon repository and prepare .env
setup:
	@echo "Creating config directory..."
	mkdir -p config
	@echo "Downloading Shannon configuration files..."
	curl -sSL https://raw.githubusercontent.com/Kocoro-lab/Shannon/main/config/models.yaml \
		-o config/models.yaml
	curl -sSL https://raw.githubusercontent.com/Kocoro-lab/Shannon/main/config/features.yaml \
		-o config/features.yaml
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "Created .env from .env.example. Edit it to add your LLM API keys."; \
	else \
		echo ".env already exists, skipping copy."; \
	fi
	@echo ""
	@echo "Setup complete! Next steps:"
	@echo "  1. Edit .env and set at least one LLM API key (OPENAI_API_KEY or ANTHROPIC_API_KEY)"
	@echo "  2. Run: make up"

# Start all services (include Temporal UI dashboard with --profile metrics)
up:
	docker compose up -d

# Start all services including Temporal UI monitoring dashboard
up-monitoring:
	docker compose --profile metrics up -d

# Stop all services
down:
	docker compose down

# View logs for all services
logs:
	docker compose logs -f

# Show service status
ps:
	docker compose ps
