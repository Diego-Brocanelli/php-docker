#!/bin/bash

set -euo pipefail

# Importação de funções e variáveis
source "scripts/variables.sh"
source "scripts/colors.sh"
source "scripts/validation.sh"
source "scripts/files.sh"
source "scripts/form.sh"
source "scripts/text.sh"
source "scripts/health_check.sh"
source "scripts/project.sh"
source "scripts/services.sh"

print_banner

check_dependency
# =======================================
# Base
# =======================================

print_section "What is the name of the project?"
PROJECT_NAME=$(define_project_name)
PROJECT_NAMESPACE=$(to_namespace "$PROJECT_NAME")
PROJECT_NAME_LOWERCASE=$(to_lower "$PROJECT_NAME")
PROJECT_NAME_SNAKE_CASE=$(replace_char "$PROJECT_NAME_LOWERCASE" " " "_")

print_success "Project name: $PROJECT_NAME"
print_success "Namespace: $PROJECT_NAMESPACE"
print_success "To lower: $PROJECT_NAME_LOWERCASE"
print_success "Snake case: $PROJECT_NAME_SNAKE_CASE"

defien_php_version

define_app_type

define_database

# =======================================
# Extra services
# =======================================
mailhog
rabbitmq
redis

# =======================================
# Generate files
# =======================================
print_section "Generating files"

generate_env_file

if [ ! -f  "${SERVICES_ROOT_DIR}/php$PHP_VERSION.yml" ]; then
    SERVICES_FILES+=("${SERVICES_ROOT_DIR}/php${PHP_VERSION,,}/php${PHP_VERSION,,}.yml")
fi

if [[ $APP_TYPE = "web" || $APP_TYPE = "api" ]]; then
    # Exemplo de uso
    TEMPLATE_FILE="${SERVICES_ROOT_DIR}/nginx/config/default.base.template.conf"
    OUTPUT_FILE="${SERVICES_ROOT_DIR}/nginx/config/default.base.conf"

    rm output_file 2>/dev/null || true

    replace_template_vars "$TEMPLATE_FILE" "$OUTPUT_FILE" "$PROJECT_NAME_SNAKE_CASE"

    SERVICES_FILES+=("${SERVICES_ROOT_DIR}/nginx/nginx.yml")
fi

if [[ "$DATABASE" != "none" && ! -f "${SERVICES_ROOT_DIR}/${DATABASE,,}.yml" ]]; then
    SERVICES_FILES+=("${SERVICES_ROOT_DIR}/$DATABASE/${DATABASE,,}.yml")
fi

if [ "$MAILHOG" == "yes" ]; then
    SERVICES_FILES+=("${SERVICES_ROOT_DIR}/mailhog/mailhog.yml")
fi

if [ "$RABBITMQ" == "yes" ]; then
    SERVICES_FILES+=("${SERVICES_ROOT_DIR}/rabbitmq/rabbitmq.yml")
fi

if [ "$REDIS" == "yes" ]; then
    SERVICES_FILES+=("${SERVICES_ROOT_DIR}/redis/redis.yml")
fi

print_section "Would you like to use the suggested structure?"
SCAFFOLD=$(choiceOption 'minimal' 'full' 'no')
if [ "$SCAFFOLD" == "minimal" ]; then
    print_success "Generating scaffold with minimal structure"

    generate_scaffold_minimal
elif [ "$SCAFFOLD" == "full" ]; then
    print_success "Generating scaffold with full structure"

    generate_scaffold_full
else
    print_success "Skipping scaffold generation"
fi

touch "$ROOT_DIR/.env"

# Construir argumentos -f
compose_args=()
for file in "${SERVICES_FILES[@]}"; do
    compose_args+=("-f" "$file")
done

if docker compose --env-file "$ROOT_DIR/.env" "${compose_args[@]}" config > "$ROOT_DIR/compose.yml"; then
    # Remove caminho absoluto para ficar relativo
    sed -i "s|$ROOT_DIR|.|g" "$ROOT_DIR/compose.yml"
    print_info "compose.yml file generated in: $ROOT_DIR/compose.yml"
else
    print_error "Failed to generate compose.yml"
    exit 1
fi

print_finish_banner
