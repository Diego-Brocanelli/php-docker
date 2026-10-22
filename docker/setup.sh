#!/usr/bin/env bash
# shellcheck source-path=SCRIPTDIR

set -euo pipefail
shopt -s inherit_errexit 2>/dev/null || true

SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Importação de funções e variáveis
source "$SETUP_DIR/scripts/variables.sh"
source "$SETUP_DIR/scripts/colors.sh"
source "$SETUP_DIR/scripts/text.sh"
source "$SETUP_DIR/scripts/validation.sh"
source "$SETUP_DIR/scripts/form.sh"
source "$SETUP_DIR/scripts/files.sh"
source "$SETUP_DIR/scripts/health_check.sh"
source "$SETUP_DIR/scripts/project.sh"
source "$SETUP_DIR/scripts/services.sh"
source "$SETUP_DIR/scripts/args.sh"

# Garante que o terminal volte a ecoar caso o setup seja interrompido durante uma senha
trap 'stty echo 2>/dev/null || true' EXIT
trap 'printf "\n" >&2; print_error "Setup cancelled."; exit 130' INT

parse_args "$@"

print_banner

check_dependency

if [[ -f "$ENV_FILE" || -f "$COMPOSE_FILE" ]]; then
    print_section "Existing configuration found"
    print_warning "The files .env and/or compose.yml already exist and will be overwritten."
    if ! confirm "Continue?"; then
        print_info "Nothing was changed."
        exit 0
    fi
fi

# =======================================
# Base
# =======================================
define_project
define_php_version
define_timezone
define_app_type
define_database

# =======================================
# Extra services
# =======================================
define_extra_services

define_composer_scaffold

# =======================================
# Generate files
# =======================================
print_section "Generating files"

generate_env_file

# O PHP vem primeiro: os demais arquivos complementam o serviço "php" (environment, depends_on)
SERVICES_FILES+=("$SERVICES_ROOT_DIR/php/php.yml")

if [[ "$APP_TYPE" == "web" || "$APP_TYPE" == "api" ]]; then
    SERVICES_FILES+=("$SERVICES_ROOT_DIR/nginx/nginx.yml")
fi

if [[ "$DATABASE" != "none" ]]; then
    SERVICES_FILES+=("$SERVICES_ROOT_DIR/$DATABASE/$DATABASE.yml")
    create_config_dirs "$DATABASE" initdb.d

    if [[ "$DATABASE" == "mariadb" || "$DATABASE" == mysql* ]]; then
        create_config_dirs "$DATABASE" conf.d
    fi
fi

for service in "${SELECTED_SERVICES[@]}"; do
    SERVICES_FILES+=("$SERVICES_ROOT_DIR/$service/$service.yml")
done

for file in "${SERVICES_FILES[@]}"; do
    file_exists "$file" "Compose template" || exit 1
done

print_section "Generating the $(to_upper "$APP_TYPE") project structure"
print_info "Existing files are never overwritten."
generate_app_entrypoint

if [[ "$COMPOSER_SCAFFOLD" == "yes" ]]; then
    generate_composer_scaffold
fi

# Construir argumentos -f
compose_args=()
for file in "${SERVICES_FILES[@]}"; do
    compose_args+=("-f" "$file")
done

# worker/scheduler recebem as mesmas variáveis de serviços que o php
php_like_services=()
for service in worker scheduler; do
    has_service "$service" && php_like_services+=("$service")
done
if (( ${#php_like_services[@]} > 0 )); then
    env_override="$(mktemp)"
    trap 'rm -f "$env_override"; stty echo 2>/dev/null || true' EXIT
    php_env_override "$env_override" "${php_like_services[@]}"
    compose_args+=("-f" "$env_override")
fi

# --no-interpolate mantém as referências ${VAR}: o .env continua sendo lido em tempo de execução
if compose_content="$(docker compose \
        --project-directory "$ROOT_DIR" \
        --env-file "$ENV_FILE" \
        "${compose_args[@]}" \
        config --no-interpolate)"; then
    # Remove o caminho absoluto para que o compose.yml fique portável
    compose_content="${compose_content//"$ROOT_DIR"/.}"
    printf '%s\n' "$compose_content" > "$COMPOSE_FILE"
    print_info "compose.yml file generated in: $COMPOSE_FILE"
else
    print_error "Failed to generate compose.yml"
    exit 1
fi

print_finish_banner

if [[ "$APP_TYPE" == "cli" ]]; then
    print_info "After 'make start', see the welcome guide with: make php c=commands/welcome.php"
else
    print_info "After 'make start', open http://localhost:$PROJECT_PORT to see the welcome guide"
fi
