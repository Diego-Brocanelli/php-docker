.PHONY: up down sh

PROJECT_NAME := $(shell grep ^PROJECT_NAME= .env | cut -d= -f2)
PROJECT_MODE := $(shell grep ^PROJECT_MODE= .env | cut -d= -f2)
PROJECT_WITH_REDIS := $(shell grep ^PROJECT_WITH_REDIS= .env | cut -d= -f2)

DOCKER_COMPOSE := $(shell command -v docker-compose >/dev/null 2>&1 && echo docker-compose || echo docker compose)

UP_PROFILES := --profile $(PROJECT_MODE)
ifeq ($(PROJECT_WITH_REDIS),TRUE)
	UP_PROFILES += --profile redis
endif

up:
	@if docker ps --format '{{.Names}}' | grep -q "^$(PROJECT_NAME)-php$$"; then \
		echo "O container $(PROJECT_NAME)-php já está rodando."; \
	else \
		$(DOCKER_COMPOSE) -p $(PROJECT_NAME) --profile $(PROJECT_MODE) $(UP_PROFILES) up -d; \
	fi

down:
	$(DOCKER_COMPOSE) -p $(PROJECT_NAME) down

sh:
	@if ! docker ps --format '{{.Names}}' | grep -q "^$(PROJECT_NAME)-php$$"; then \
		$(DOCKER_COMPOSE) -p $(PROJECT_NAME) --profile $(PROJECT_MODE) $(UP_PROFILES) up -d; \
	fi; \
	docker exec -it $(PROJECT_NAME)-php bash
