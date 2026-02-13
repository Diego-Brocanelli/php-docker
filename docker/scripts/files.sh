generate_env_file()
{
    local variables_file="${DOCKER_DIR}/scripts/variables.sh"
    local ENV_FILE="$ROOT_DIR/.env"

    # Blacklist: variáveis que NÃO devem ir para o .env
    local blacklist=(
        "RABBITMQ"
        "REDIS"
        "MAILHOG"
        "ROOT_DIR"
        "DOCKER_DIR"
        "SCRIPT_DIR"
        "ENV_FILE"
        "SERVICES_ROOT_DIR"
        "BASE_COMPOSE_FILE"
        "TEMP_DIR"
        "SERVICES_FILES"
        "PHP_VERSION"
        "PROJECT_NAMESPACE"
        "PROJECT_NAME_LOWERCASE"
    )

    > "$ENV_FILE"

    grep -E '^[A-Za-z_][A-Za-z0-9_]*=' "$variables_file" | cut -d'=' -f1 | while read -r var_name; do
        # Verifica se está na blacklist
        if [[ " ${blacklist[@]} " =~ " ${var_name} " ]]; then
            continue
        fi

        var_name_upper="${var_name^^}"

        if ! declare -p "$var_name" &>/dev/null; then
            continue
        fi

        if declare -p "$var_name" 2>/dev/null | grep -qE 'declare -[aA]'; then
            continue
        fi

        # Pega o valor atual da variável EM MEMÓRIA (SEM aspas extras)
        value="${!var_name}"

        # Só adiciona se não estiver vazio
        if [ -n "$value" ]; then
            # Adiciona aspas duplas se houver espaços, senão sem aspas
            if [[ "$value" == *" "* ]]; then
                echo "$var_name_upper=\"$value\"" >> "$ENV_FILE"
            else
                echo "$var_name_upper=$value" >> "$ENV_FILE"
            fi
        fi
    done

    print_info ".env file generated in: $ENV_FILE"
}

generate_scaffold_minimal()
{
    remove_scaffold

    if [[ $APP_TYPE = "web" ]]; then
        generate_web_scaffold
    elif [[ $APP_TYPE = "api" ]]; then
        generate_api_scaffold
    elif [[ $APP_TYPE = "cli" ]]; then
        generate_cli_scaffold
    fi
}

generate_scaffold_full()
{
    remove_scaffold

    if [[ $APP_TYPE = "web" ]]; then
        generate_web_scaffold
    elif [[ $APP_TYPE = "api" ]]; then
        generate_api_scaffold
    elif [[ $APP_TYPE = "cli" ]]; then
        generate_cli_scaffold
    fi
}

generate_web_scaffold()
{
    local public_dir="$ROOT_DIR/public"

    rm -rf "$public_dir"

    mkdir -p "$public_dir"

    if [[ ! -f "$public_dir/index.php" ]]; then
        cat > "$public_dir/index.php" <<'EOL'
<?php

declare(strict_types=1);

phpinfo();
EOL
    fi
}

generate_api_scaffold()
{
    local public_dir="$ROOT_DIR/public"

    rm -rf "$public_dir"

    mkdir -p "$public_dir"

    if [[ ! -f "$public_dir/index.php" ]]; then
        cat > "$public_dir/index.php" <<'EOL'
<?php

declare(strict_types=1);

header('Content-Type: application/json');

echo "Hello, API!";
EOL
    fi
}

generate_cli_scaffold()
{
    local command_dir="$ROOT_DIR/command"

    rm -rf "$command_dir"

    mkdir -p "$command_dir"

    if [[ ! -f "$command_dir/test.php" ]]; then
        cat > "$command_dir/test.php" <<'EOL'
<?php

echo "Hello, CLI!";
EOL
    fi
}

remove_scaffold()
{
    rm -rf "$ROOT_DIR/public" "$ROOT_DIR/command" 2>/dev/null || true
}
