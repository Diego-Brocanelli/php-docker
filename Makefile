# Makefile para Projeto PHP Docker
# Comandos para gerenciar o ambiente de desenvolvimento

.PHONY: help setup start stop restart logs logs-php logs-nginx shell shell-root \
	rebuild clean destroy clean-all status test install update composer php \
	lint fix stan audit build-prod mysql mariadb postgres mongo redis \
	logs-worker logs-scheduler worker-restart check-generated check-vendor up down ps exec

# Variáveis
SETUP_DIR = ./docker
COMPOSE = docker compose --env-file .env
EXEC_PHP = $(COMPOSE) exec php

# Argumentos repassados: make setup ARGS="--type api --yes" | make composer c="require x/y"
ARGS ?=
c ?=

# Comando padrão
help: ## Mostra esta ajuda
	@echo "Comandos disponíveis:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""

setup: ## Configura o projeto (interativo; use ARGS="--help" para ver as opções)
	@bash $(SETUP_DIR)/setup.sh $(ARGS)

start: check-generated ## Inicia os containers
	@echo "🚀 Iniciando containers..."
	@$(COMPOSE) up -d --wait
	@echo "✅ Containers iniciados!"
	@$(MAKE) --no-print-directory status

stop: check-generated ## Para os containers
	@echo "🛑 Parando containers..."
	@$(COMPOSE) down
	@echo "✅ Containers parados!"

restart: check-generated ## Reinicia os containers (relê o .env)
	@echo "🔄 Reiniciando containers..."
	@$(COMPOSE) up -d --wait --force-recreate
	@echo "✅ Containers reiniciados!"

logs: check-generated ## Mostra logs dos containers
	@$(COMPOSE) logs -f

logs-php: check-generated ## Mostra logs apenas do PHP
	@$(COMPOSE) logs -f php

logs-nginx: check-generated ## Mostra logs apenas do Nginx
	@$(COMPOSE) logs -f nginx

logs-worker: check-generated ## Mostra logs do worker
	@$(COMPOSE) logs -f worker

logs-scheduler: check-generated ## Mostra logs do agendador (cron)
	@$(COMPOSE) logs -f scheduler

worker-restart: check-generated ## Reinicia o worker (necessário após alterar o código dele)
	@echo "🔄 Reiniciando worker..."
	@$(COMPOSE) restart worker
	@echo "✅ Worker reiniciado!"

shell: check-generated ## Acessa o shell do container PHP
	@echo "🐚 Acessando container PHP..."
	@$(EXEC_PHP) bash

shell-root: check-generated ## Acessa o shell do container PHP como root
	@echo "🐚 Acessando container PHP como root..."
	@$(COMPOSE) exec -u root php bash

rebuild: check-generated ## Reconstroi e reinicia os containers
	@echo "🔨 Reconstruindo containers..."
	@$(COMPOSE) up --build -d --wait
	@echo "✅ Containers reconstruídos!"

clean: check-generated ## Remove containers e redes (os dados dos bancos são mantidos)
	@echo "🧹 Limpando ambiente Docker..."
	@$(COMPOSE) down --remove-orphans
	@echo "✅ Ambiente limpo! Os volumes de dados foram mantidos."

destroy: check-generated ## Remove containers E os volumes de dados (apaga os bancos!)
	@printf "⚠️  Isso apaga TODOS os dados dos bancos e caches deste projeto. Continuar? [y/N] "; \
	read answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		$(COMPOSE) down -v --remove-orphans && echo "✅ Containers e volumes removidos!"; \
	else \
		echo "Nada foi removido."; \
	fi

clean-all: clean ## Remove também .env e compose.yml (os volumes de dados são mantidos)
	@echo "🗑️  Removendo arquivos gerados..."
	@rm -f .env compose.yml
	@echo "✅ Tudo removido! Execute 'make setup' para reconfigurar."

status: check-generated ## Mostra status dos containers
	@echo "📊 Status dos containers:"
	@$(COMPOSE) ps

install: check-generated ## Instala dependências do Composer
	@echo "📦 Instalando dependências..."
	@$(EXEC_PHP) composer install

update: check-generated ## Atualiza dependências do Composer
	@echo "⬆️  Atualizando dependências..."
	@$(EXEC_PHP) composer update

composer: check-generated ## Executa o Composer: make composer c="require vendor/pacote"
	@$(EXEC_PHP) composer $(c)

php: check-generated ## Executa um script PHP: make php c=commands/welcome.php
	@$(EXEC_PHP) php $(c)

test: check-vendor ## Executa os testes (PHPUnit)
	@echo "🧪 Executando testes..."
	@$(EXEC_PHP) composer test

stan: check-vendor ## Análise estática (PHPStan)
	@echo "🔎 Executando PHPStan..."
	@$(EXEC_PHP) composer stan

lint: check-vendor ## Verifica o padrão de código (PHP-CS-Fixer, sem alterar)
	@echo "🧹 Verificando padrão de código..."
	@$(EXEC_PHP) composer cs

fix: check-vendor ## Corrige o padrão de código (PHP-CS-Fixer)
	@echo "🛠️  Corrigindo padrão de código..."
	@$(EXEC_PHP) composer cs:fix

audit: check-vendor ## Verifica vulnerabilidades conhecidas nas dependências
	@echo "🛡️  Auditando dependências..."
	@$(EXEC_PHP) composer audit

build-prod: check-generated ## Gera as imagens de produção (<projeto>_php:prod e, em web/api, <projeto>_nginx:prod)
	@set -a; . ./.env; set +a; \
	echo "🏭 Gerando $${PROJECT_NAME_SNAKE_CASE}_php:prod..."; \
	docker build --target prod \
		--build-arg PHP_VERSION="$$PHP_VERSION" \
		--build-arg PHP_EXTENSIONS="$$PHP_EXTENSIONS" \
		-f docker/templates/services/php/Dockerfile \
		-t "$${PROJECT_NAME_SNAKE_CASE}_php:prod" . && \
	if [ "$$APP_TYPE" != "cli" ]; then \
		echo "🏭 Gerando $${PROJECT_NAME_SNAKE_CASE}_nginx:prod..."; \
		docker build -f docker/templates/services/nginx/Dockerfile \
			-t "$${PROJECT_NAME_SNAKE_CASE}_nginx:prod" .; \
	fi && echo "✅ Imagens de produção geradas!"

mysql: check-generated ## Acessa o MySQL via CLI
	@echo "🐬 Conectando ao MySQL..."
	@$(COMPOSE) exec mysql sh -c 'MYSQL_PWD="$$MYSQL_PASSWORD" mysql -u"$$MYSQL_USER" "$$MYSQL_DATABASE"'

mariadb: check-generated ## Acessa o MariaDB via CLI
	@echo "🦭 Conectando ao MariaDB..."
	@$(COMPOSE) exec mariadb sh -c 'MYSQL_PWD="$$MARIADB_PASSWORD" mariadb -u"$$MARIADB_USER" "$$MARIADB_DATABASE"'

postgres: check-generated ## Acessa o PostgreSQL via CLI
	@echo "🐘 Conectando ao PostgreSQL..."
	@$(COMPOSE) exec postgresql sh -c 'psql -U "$$POSTGRES_USER" -d "$$POSTGRES_DB"'

mongo: check-generated ## Acessa o MongoDB via CLI
	@echo "🍃 Conectando ao MongoDB..."
	@$(COMPOSE) exec mongodb sh -c 'mongosh -u "$$MONGO_INITDB_ROOT_USERNAME" -p "$$MONGO_INITDB_ROOT_PASSWORD" --authenticationDatabase admin "$$MONGO_INITDB_DATABASE"'

redis: check-generated ## Acessa o Redis CLI
	@echo "🔴 Conectando ao Redis..."
	@$(COMPOSE) exec redis redis-cli

# Comando interno para verificar se o setup foi executado
check-generated:
	@if [ ! -f ".env" ] || [ ! -f "compose.yml" ]; then \
		echo "❌ Projeto não configurado. Execute: make setup"; \
		exit 1; \
	fi

# Comando interno para verificar se as dependências do Composer foram instaladas
check-vendor: check-generated
	@if [ ! -f "composer.json" ]; then \
		echo "❌ composer.json não encontrado. Rode 'make setup' com a estrutura Composer ou 'make composer c=init'."; \
		exit 1; \
	fi
	@if [ ! -d "vendor" ]; then \
		echo "❌ Dependências não instaladas. Execute: make install"; \
		exit 1; \
	fi

# Aliases para comandos comuns
up: start ## Alias para start
down: stop ## Alias para stop
ps: status ## Alias para status
exec: shell ## Alias para shell
