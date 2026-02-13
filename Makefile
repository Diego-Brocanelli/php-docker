# Makefile para Projeto PHP Docker
# Comandos para gerenciar o ambiente de desenvolvimento

.PHONY: help setup start stop restart logs shell rebuild clean status test

# Variáveis
DOCKER_DIR = docker
COMPOSE_FILE = compose.yml
SCRIPT_DIR = ./docker/scripts
SETUP_DIR = ./docker

# Comando padrão
help: ## Mostra esta ajuda
	@echo "Comandos disponíveis:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $1, $2}'
	@echo ""

setup: ## Configura o projeto Docker (primeira vez)
	@cd $(SETUP_DIR) && ./setup.sh

start: check-generated ## Inicia os containers
	@echo "🚀 Iniciando containers..."
	@docker compose --verbose --env-file .env up -d
	@echo "✅ Containers iniciados!"
	@make status

stop: check-generated ## Para os containers
	@echo "🛑 Parando containers..."
	@docker compose --env-file .env down
	@echo "✅ Containers parados!"

restart: check-generated ## Reinicia os containers
	@echo "🔄 Reiniciando containers..."
	@docker compose --env-file .env restart
	@echo "✅ Containers reiniciados!"

logs: check-generated ## Mostra logs dos containers
	@docker compose --env-file .env logs -f

logs-php: check-generated ## Mostra logs apenas do PHP
	@docker compose --env-file .env logs -f php

logs-nginx: check-generated ## Mostra logs apenas do Nginx
	@docker compose --env-file .env logs -f nginx

shell: check-generated ## Acessa o shell do container PHP
	@echo "🐚 Acessando container PHP..."
	@docker compose --env-file .env exec php bash

shell-root: check-generated ## Acessa o shell do container PHP como root
	@echo "🐚 Acessando container PHP como root..."
	@docker compose --env-file .env exec -u root php bash

rebuild: check-generated ## Reconstroi e reinicia os containers
	@echo "🔨 Reconstruindo containers..."
	@docker compose --env-file .env up --build -d
	@echo "✅ Containers reconstruídos!"

clean: check-generated ## Remove containers, volumes e imagens
	@echo "🧹 Limpando ambiente Docker..."
	@docker compose --env-file .env down -v --remove-orphans
	@echo "✅ Ambiente limpo!"

clean-all: clean ## Remove tudo incluindo arquivos gerados
	@echo "🗑️  Removendo arquivos gerados..."
	@rm -f .env compose.yml docker-compose.sh
	@echo "✅ Tudo removido! Execute 'make setup' para reconfigurar."

status: check-generated ## Mostra status dos containers
	@echo "📊 Status dos containers:"
	@docker compose --env-file .env ps

test: check-generated ## Executa testes dentro do container
	@echo "🧪 Executando testes..."
	@docker compose --env-file .env exec php vendor/bin/phpunit

install: check-generated ## Instala dependências do Composer
	@echo "📦 Instalando dependências..."
	@docker compose --env-file .env exec php composer install

update: check-generated ## Atualiza dependências do Composer
	@echo "⬆️  Atualizando dependências..."
	@docker compose --env-file .env exec php composer update

mysql: check-generated ## Acessa o MySQL via CLI
	@echo "🐬 Conectando ao MySQL..."
	@docker compose --env-file .env exec mysql mysql -uroot -p

postgres: check-generated ## Acessa o PostgreSQL via CLI
	@echo "🐘 Conectando ao PostgreSQL..."
	@docker compose --env-file .env exec postgres psql -U app_user -d app_db

REDIS: check-generated ## Acessa o REDIS CLI
	@echo "🔴 Conectando ao REDIS..."
	@docker compose --env-file .env exec REDIS REDIS-cli

# Comando interno para verificar se o setup foi executado
check-generated:
	@if [ ! -f ".env" ] || [ ! -f "compose.yml" ]; then \
		echo "❌ Projeto não configurado. Execute: make setup"; \
		exit 1; \
	fi

# Aliases para comandos comuns
up: start ## Alias para start
down: stop ## Alias para stop
ps: status ## Alias para status
exec: shell ## Alias para shell