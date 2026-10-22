#!/usr/bin/env bash
# shellcheck disable=SC2034 # Variáveis lidas indiretamente (write_env_var)
#
# Cada define_* pergunta apenas o que ainda não veio preenchido pelas flags (scripts/args.sh).
# Valores vindos de flags são validados; valor inválido encerra o setup.

fail_flag() {
    print_error "$1"
    exit 1
}

# ask_choice <variável> "<nome>" <opção padrão> <opção 2> ...
ask_choice() {
    local -n __choice_ref="$1"
    local name="$2"
    shift 2
    local option

    if [[ -n "$__choice_ref" ]]; then
        for option in "$@"; do
            [[ "$option" == "$__choice_ref" ]] && return 0
        done
        fail_flag "Invalid $name: '$__choice_ref' (options: $*)"
    fi

    __choice_ref="$(choiceOption "$@")"
}

# ask_port <variável> "<label>" "<padrão>" - reserva a porta para que nenhum outro serviço a utilize
ask_port() {
    local -n __port_ref="$1"
    local label="$2"
    local default_value="$3"

    if [[ -n "$__port_ref" ]]; then
        is_valid_port "$__port_ref" || fail_flag "Invalid $label: '$__port_ref' (use 1-65535)"
        __port_ref="$(( 10#$__port_ref ))"
        is_port_used "$__port_ref" && fail_flag "$label $__port_ref is already used by another service"
    else
        __port_ref="$(inputPort "$label" "$default_value")"
    fi

    USED_PORTS+=("$__port_ref")
}

# ask_identifier <variável> "<label>" "<padrão>"
ask_identifier() {
    local -n __id_ref="$1"
    local label="$2"
    local default_value="$3"

    if [[ -n "$__id_ref" ]]; then
        is_valid_identifier "$__id_ref" || fail_flag "Invalid $label: '$__id_ref' (use letters, numbers and _)"
        return 0
    fi

    __id_ref="$(inputIdentifier "$label" "$default_value")"
}

# ask_password <variável> "<label>" ["<padrão>"]
ask_password() {
    local -n __pw_ref="$1"
    local label="$2"
    local default_value="${3:-}"

    if [[ -n "$__pw_ref" ]]; then
        is_valid_password "$__pw_ref" || fail_flag "Invalid $label: use only letters, numbers and . _ ~ ! * + = , -"
        return 0
    fi

    __pw_ref="$(inputPassword "$label" "$default_value")"
}

add_php_extension() {
    PHP_EXTENSIONS="${PHP_EXTENSIONS:+$PHP_EXTENSIONS }$1"
}

define_project() {
    local default_name=""

    print_section "What is the name of the project?"

    if [[ -n "$PROJECT_NAME" ]]; then
        is_valid_project_name "$PROJECT_NAME" \
            || fail_flag "Invalid project name: start with a letter; use letters, numbers, spaces, _ or - (max. 50)"
    else
        # Sugere o nome do diretório do projeto
        if is_valid_project_name "$(basename "$ROOT_DIR")"; then
            default_name="$(basename "$ROOT_DIR")"
        fi
        PROJECT_NAME="$(define_project_name "$default_name")"
    fi

    PROJECT_NAMESPACE="$(to_namespace "$PROJECT_NAME")"
    PROJECT_NAME_SNAKE_CASE="$(to_snake_case "$PROJECT_NAME")"

    print_success "Project name: $PROJECT_NAME"
    print_success "Namespace: $PROJECT_NAMESPACE"
    print_success "Snake case: $PROJECT_NAME_SNAKE_CASE"
}

define_php_version() {
    print_section "Which version of PHP do you want to use?"
    ask_choice PHP_VERSION "PHP version" '8.5' '8.4'
    print_success "PHP version: $PHP_VERSION"
}

# Timezone do host (link /etc/localtime ou /etc/timezone); UTC se não for possível detectar
detect_timezone() {
    local tz=""

    if [[ -L /etc/localtime ]]; then
        tz="$(readlink /etc/localtime)"
        tz="${tz#*zoneinfo/}"
    elif [[ -r /etc/timezone ]]; then
        tz="$(< /etc/timezone)"
    fi

    if [[ -n "$tz" ]] && is_valid_timezone "$tz"; then
        printf '%s' "$tz"
    else
        printf 'UTC'
    fi
}

define_timezone() {
    print_section "Which timezone should the containers use?"

    if [[ -n "$TZ_VALUE" ]]; then
        is_valid_timezone "$TZ_VALUE" || fail_flag "Invalid timezone: '$TZ_VALUE' (e.g. America/Sao_Paulo, UTC)"
    else
        while true; do
            TZ_VALUE="$(inputText "Timezone" "$(detect_timezone)")"
            is_valid_timezone "$TZ_VALUE" && break
            print_error "Invalid timezone: '$TZ_VALUE' (e.g. America/Sao_Paulo, UTC)"
            (( NON_INTERACTIVE )) && exit 1
        done
    fi

    print_success "Timezone: $TZ_VALUE"
}

define_app_type() {
    print_section "Which project do you want to start?"
    ask_choice APP_TYPE "project type" 'web' 'api' 'cli'
    print_success "Project type: $(to_upper "$APP_TYPE")"

    if [[ "$APP_TYPE" == "web" || "$APP_TYPE" == "api" ]]; then
        ask_port PROJECT_PORT "HTTP port" "8080"
        print_success "HTTP port: $PROJECT_PORT"
    elif [[ -n "$PROJECT_PORT" ]]; then
        print_warning "--port is ignored for cli projects"
        PROJECT_PORT=""
    fi
}

define_database() {
    local default_port

    print_section "Do you want to use a Database?"
    [[ "$DATABASE" == "postgres" ]] && DATABASE="postgresql"
    ask_choice DATABASE "database" 'none' 'mariadb' 'mongodb' 'mysql8.4' 'mysql8.0' 'postgresql'
    print_success "Database: $(to_upper "$DATABASE")"

    case "$DATABASE" in
        none)
            return 0
            ;;
        mariadb|mysql8.4)
            default_port="3306"
            ;;
        mysql8.0)
            default_port="3306"
            print_warning "MySQL 8.0 reached end of life in April 2026. Prefer mysql8.4 (LTS)."
            ;;
        mongodb)
            default_port="27017"
            add_php_extension "mongodb"
            ;;
        postgresql)
            default_port="5432"
            add_php_extension "pdo_pgsql"
            ;;
    esac

    ask_port DB_PORT "Database port" "$default_port"
    print_success "Database port: $DB_PORT"

    ask_identifier DB_NAME "Database name" "app"
    print_success "Database name: $DB_NAME"

    # MongoDB e PostgreSQL usam o usuário informado como administrador
    ask_identifier DB_USER "Database user" "app"
    print_success "Database user: $DB_USER"

    ask_password DB_PASSWORD "Database password" "app"
    print_success "Database password saved in .env"

    if [[ "$DATABASE" == "mariadb" || "$DATABASE" == mysql* ]]; then
        ask_password DB_ROOT_PASSWORD "Database root password" "app"
        print_success "Database root password saved in .env"
    else
        DB_ROOT_PASSWORD=""
    fi
}

# =======================================
# Serviços extras
# =======================================
# Ordem exibida no menu. Cada serviço tem um template em
# docker/templates/services/<nome>/<nome>.yml e uma função configure_<nome>.
EXTRA_SERVICES=(mailpit rabbitmq redis memcached meilisearch opensearch elasticsearch rustfs kafka mercure selenium worker scheduler)

declare -A SERVICE_LABELS=(
    [mailpit]="Mailpit        - SMTP testing with web UI"
    [rabbitmq]="RabbitMQ       - message broker (AMQP)"
    [redis]="Redis          - cache, sessions and queues"
    [memcached]="Memcached      - in-memory cache"
    [meilisearch]="Meilisearch    - lightweight full-text search"
    [opensearch]="OpenSearch     - search and analytics (needs ~1 GB RAM)"
    [elasticsearch]="Elasticsearch  - search and analytics (needs ~1 GB RAM)"
    [rustfs]="RustFS         - S3-compatible object storage"
    [kafka]="Kafka          - event streaming (KRaft)"
    [mercure]="Mercure        - real-time updates (Server-Sent Events)"
    [selenium]="Selenium       - headless Chromium for end-to-end tests"
    [worker]="Worker         - long-running PHP process (queue consumer)"
    [scheduler]="Scheduler      - cron for PHP commands (supercronic)"
)

# Serviços escolhidos (preenchido pelo menu ou por --services)
SELECTED_SERVICES=()

has_service() {
    [[ " ${SELECTED_SERVICES[*]} " == *" $1 "* ]]
}

is_known_service() {
    [[ " ${EXTRA_SERVICES[*]} " == *" $1 "* ]]
}

# Converte a lista de flags ("redis,worker" ou "all") e --mailpit/--rabbitmq/--redis yes
resolve_service_flags() {
    local name

    if [[ "$SERVICES_FLAG" == "all" ]]; then
        SELECTED_SERVICES=("${EXTRA_SERVICES[@]}")
    elif [[ -n "$SERVICES_FLAG" && "$SERVICES_FLAG" != "none" ]]; then
        for name in ${SERVICES_FLAG//,/ }; do
            is_known_service "$name" || fail_flag "Unknown service: '$name' (options: ${EXTRA_SERVICES[*]})"
            has_service "$name" || SELECTED_SERVICES+=("$name")
        done
    fi

    for name in mailpit rabbitmq redis; do
        local -n __legacy_ref="${name^^}"
        case "$__legacy_ref" in
            yes) has_service "$name" || SELECTED_SERVICES+=("$name") ;;
            no|"") ;;
            *) fail_flag "Invalid --$name value: '$__legacy_ref' (options: yes no)" ;;
        esac
        unset -n __legacy_ref
    done
}

define_extra_services() {
    local -a labels=()
    local name index

    print_section "Which extra services do you want to include?"

    resolve_service_flags

    # Pergunta apenas se nada veio pelas flags
    if (( ${#SELECTED_SERVICES[@]} == 0 )) && [[ -z "$SERVICES_FLAG$MAILPIT$RABBITMQ$REDIS" ]]; then
        for name in "${EXTRA_SERVICES[@]}"; do
            labels+=("${SERVICE_LABELS[$name]}")
        done

        for index in $(multiChoice "${labels[@]}"); do
            SELECTED_SERVICES+=("${EXTRA_SERVICES[$index]}")
        done
    fi

    if (( ${#SELECTED_SERVICES[@]} == 0 )); then
        print_success "Extra services: NONE"
        return 0
    fi

    print_success "Extra services: ${SELECTED_SERVICES[*]}"

    # Mantém a ordem do catálogo ao configurar
    for name in "${EXTRA_SERVICES[@]}"; do
        if has_service "$name"; then
            "configure_$name"
        fi
    done
}

configure_mailpit() {
    print_info "Mailpit"
    ask_port MAILPIT_SMTP_PORT "Mailpit SMTP port" "1025"
    ask_port MAILPIT_WEB_PORT "Mailpit web port" "8025"
    print_success "Mailpit: SMTP $MAILPIT_SMTP_PORT, web $MAILPIT_WEB_PORT"
}

configure_rabbitmq() {
    print_info "RabbitMQ"
    add_php_extension "amqp"
    ask_port RABBITMQ_PORT "RabbitMQ port" "5672"
    ask_port RABBITMQ_WEB_PORT "RabbitMQ management port" "15672"
    ask_identifier RABBITMQ_USER "RabbitMQ user" "app"
    ask_password RABBITMQ_PASSWORD "RabbitMQ password"
    print_success "RabbitMQ: port $RABBITMQ_PORT, management $RABBITMQ_WEB_PORT, user $RABBITMQ_USER (password saved in .env)"
}

configure_redis() {
    print_info "Redis"
    ask_port REDIS_PORT "Redis port" "6379"
    print_success "Redis: port $REDIS_PORT"
}

configure_memcached() {
    print_info "Memcached"
    add_php_extension "memcached"
    ask_port MEMCACHED_PORT "Memcached port" "11211"
    print_success "Memcached: port $MEMCACHED_PORT"
}

configure_meilisearch() {
    print_info "Meilisearch"
    ask_port MEILISEARCH_PORT "Meilisearch port" "7700"
    # A master key precisa de pelo menos 16 bytes
    MEILISEARCH_KEY="${MEILISEARCH_KEY:-$(generate_password)}"
    print_success "Meilisearch: port $MEILISEARCH_PORT (master key saved in .env)"
}

configure_opensearch() {
    print_info "OpenSearch"
    ask_port OPENSEARCH_PORT "OpenSearch port" "9201"
    print_success "OpenSearch: port $OPENSEARCH_PORT"
    warn_max_map_count
}

configure_elasticsearch() {
    print_info "Elasticsearch"
    ask_port ELASTICSEARCH_PORT "Elasticsearch port" "9200"
    print_success "Elasticsearch: port $ELASTICSEARCH_PORT"
    warn_max_map_count
}

configure_rustfs() {
    print_info "RustFS (S3)"
    ask_port RUSTFS_PORT "RustFS S3 port" "9000"
    ask_port RUSTFS_CONSOLE_PORT "RustFS console port" "9001"
    ask_identifier RUSTFS_ACCESS_KEY "RustFS access key" "app"
    while true; do
        ask_password RUSTFS_SECRET_KEY "RustFS secret key" "app12345"
        (( ${#RUSTFS_SECRET_KEY} >= 8 )) && break
        print_error "The RustFS secret key must have at least 8 characters"
        RUSTFS_SECRET_KEY=""
        (( NON_INTERACTIVE )) && exit 1
    done
    print_success "RustFS: S3 $RUSTFS_PORT, console $RUSTFS_CONSOLE_PORT, access key $RUSTFS_ACCESS_KEY (secret saved in .env)"
}

configure_kafka() {
    print_info "Kafka"
    add_php_extension "rdkafka"
    ask_port KAFKA_PORT "Kafka port (from your machine)" "9094"
    print_success "Kafka: port $KAFKA_PORT"
}

configure_mercure() {
    print_info "Mercure"
    ask_port MERCURE_PORT "Mercure port" "3000"
    # HS256 exige chave de pelo menos 256 bits
    MERCURE_JWT_SECRET="${MERCURE_JWT_SECRET:-$(generate_password)$(generate_password)}"
    print_success "Mercure: port $MERCURE_PORT (JWT secret saved in .env)"
}

configure_selenium() {
    print_info "Selenium"
    ask_port SELENIUM_PORT "Selenium WebDriver port" "4444"
    ask_port SELENIUM_VNC_PORT "Selenium noVNC port (watch the browser)" "7900"
    print_success "Selenium: WebDriver $SELENIUM_PORT, noVNC $SELENIUM_VNC_PORT"
}

configure_worker() {
    print_info "Worker: runs commands/worker.php continuously (change WORKER_COMMAND in .env)"
    WORKER_COMMAND="${WORKER_COMMAND:-commands/worker.php}"
    print_success "Worker: php $WORKER_COMMAND"
}

configure_scheduler() {
    print_info "Scheduler: cron jobs in docker/templates/services/scheduler/crontab"
    print_success "Scheduler: enabled"
}

warn_max_map_count() {
    local current

    current="$(cat /proc/sys/vm/max_map_count 2>/dev/null || echo 0)"
    if (( current < 262144 )); then
        print_warning "vm.max_map_count is $current; OpenSearch/Elasticsearch need at least 262144."
        print_info "Run: sudo sysctl -w vm.max_map_count=262144 (add it to /etc/sysctl.conf to keep it)"
    fi
}

define_composer_scaffold() {
    print_section "Would you like to include the Composer structure?"
    print_info "composer.json (PSR-4: $PROJECT_NAMESPACE\\ -> src/), src/, tests/, PHPUnit, PHPStan and PHP-CS-Fixer"
    ask_choice COMPOSER_SCAFFOLD "--composer value" 'yes' 'no'
    print_success "Composer structure: $(to_upper "$COMPOSER_SCAFFOLD")"
}
