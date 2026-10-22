#!/usr/bin/env bash
# shellcheck disable=SC2034 # Variáveis consumidas por services.sh

print_usage() {
    cat >&2 <<'EOL'
Usage: docker/setup.sh [options]

Without options the setup is interactive. Any option given skips its question.

Project:
  --name <name>               Project name
  --php <8.5|8.4>             PHP version
  --type <web|api|cli>        Project type
  --port <port>               HTTP port (web/api)
  --timezone <tz>             Timezone, e.g. America/Sao_Paulo
  --composer <yes|no>         Create composer.json, src/, tests/ and quality tools

Database:
  --db <none|mariadb|mongodb|mysql8.4|mysql8.0|postgresql>
  --db-port <port>
  --db-name <name>
  --db-user <user>
  --db-password <password>    (default: app)
  --db-root-password <pass>   MySQL/MariaDB only (default: app)

Extra services:
  --services <list|all|none>  Comma-separated list of extra services:
                              mailpit, rabbitmq, redis, memcached, meilisearch,
                              opensearch, elasticsearch, rustfs, kafka, mercure,
                              selenium, worker, scheduler
  --mailpit <yes|no>          Same as adding mailpit to --services
  --rabbitmq <yes|no>         Same as adding rabbitmq to --services
  --redis <yes|no>            Same as adding redis to --services

Behaviour:
  -y, --yes                   Non-interactive: use defaults for everything not given
                              and overwrite existing .env/compose.yml
  -h, --help                  Show this help

Note: passwords given as options are visible in the shell history.

Example:
  make setup ARGS="--name 'My Api' --type api --db postgresql --services redis,worker --yes"
EOL
}

# parse_args "$@" - aceita "--opcao valor" e "--opcao=valor"
parse_args() {
    local option value

    while (( $# > 0 )); do
        option="$1"
        value=""

        case "$option" in
            -h|--help)
                print_usage
                exit 0
                ;;
            -y|--yes)
                NON_INTERACTIVE=1
                shift
                continue
                ;;
            --*=*)
                value="${option#*=}"
                option="${option%%=*}"
                shift
                ;;
            --*)
                if (( $# < 2 )) || [[ "$2" == --* ]]; then
                    print_error "Missing value for $option"
                    exit 1
                fi
                value="$2"
                shift 2
                ;;
            *)
                print_error "Unknown argument: $option (see --help)"
                exit 1
                ;;
        esac

        case "$option" in
            --name)             PROJECT_NAME="$value" ;;
            --php)              PHP_VERSION="$value" ;;
            --type)             APP_TYPE="$value" ;;
            --port)             PROJECT_PORT="$value" ;;
            --timezone)         TZ_VALUE="$value" ;;
            --composer)         COMPOSER_SCAFFOLD="$value" ;;
            --db)               DATABASE="$value" ;;
            --db-port)          DB_PORT="$value" ;;
            --db-name)          DB_NAME="$value" ;;
            --db-user)          DB_USER="$value" ;;
            --db-password)      DB_PASSWORD="$value" ;;
            --db-root-password) DB_ROOT_PASSWORD="$value" ;;
            --mailpit)          MAILPIT="$value" ;;
            --rabbitmq)         RABBITMQ="$value" ;;
            --redis)            REDIS="$value" ;;
            --services)         SERVICES_FLAG="$value" ;;
            *)
                print_error "Unknown option: $option (see --help)"
                exit 1
                ;;
        esac
    done
}
