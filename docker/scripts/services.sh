defien_php_version()
{
    print_section "Which version of PHP do you want to use?"
    PHP_VERSION=$(choiceOption '8.4' '8.3' '8.2')
    print_success "PHP version: $PHP_VERSION"
}

define_app_type()
{
    print_section "Which project do you want to start?"
    APP_TYPE=$(choiceOption 'web' 'api' 'cli')
    print_success "Project type: $(to_upper "$APP_TYPE")"

    if [[ $APP_TYPE = "web" || $APP_TYPE = "api" ]]; then
        define_app_port
    fi
}

define_app_port()
{
    print_info "Default port for Web or API projects is 8080"
    PROJECT_PORT=$(inputText "Port" "8080")
    print_success "Port: $PROJECT_PORT"

    print_info "Default HTTPS port for Web or API projects is 8443"
    PROJECT_HTTPS_PORT=$(inputText "HTTPS Port" "8443")
    print_success "HTTPS Port: $PROJECT_HTTPS_PORT"
}

define_database()
{
    print_section "Do you want to use a Database?"
    DATABASE=$(choiceOption 'none' 'mariadb' 'mongodb' 'postgresql')
    print_success "Database: $(to_upper "$DATABASE")"

    if [ $DATABASE = "none" ]; then
        return

    fi

    default_port=""

    case $DATABASE in
        mariadb)
            default_port="3306"
            ;;
        mongodb)
            default_port="27017"
            ;;
        postgresql)
            default_port="5432"
            ;;
        REDIS)
            default_port="6379"
            ;;
        *)
            print_error "Database '$DATABASE' unknown"
            default_port="3306"
            ;;
    esac

    print_info "Default port for $DATABASE is $default_port"
    DB_PORT=$(inputText "Default port ${default_port}" "${default_port}")
    print_success "Database port: $DB_PORT"

    print_info "Default root password for $DATABASE is 'app'"
    DB_ROOT_PASSWORD=$(inputText "Password root: default app" "app")
    # DB_ROOT_PASSWORD=$(check_empty "$DB_ROOT_PASSWORD" "Default root" "root")
    print_success "Password root: $DB_ROOT_PASSWORD"

    print_info "Default Database name for $DATABASE is 'app'"
    DB_NAME=$(inputText "Database name: default app" "app")
    # DB_NAME=$(check_empty "$DB_NAME" "Default app" "app")
    print_success "Database name: $DB_NAME"

    print_info "Default Database user for $DATABASE is 'app'"
    DB_USER=$(inputText "Database user: default app" "app")
    # DB_USER=$(check_empty "$DB_USER" "Default app" "app")
    print_success "Database user: $DB_USER"

    print_info "Default Database password for $DATABASE is 'app'"
    DB_PASSWORD=$(inputText "Database password: default app" "app")
    # DB_PASSWORD=$(check_empty "$DB_PASSWORD" "Default app" "app")
    print_success "Database password: $DB_PASSWORD"
}

function mailhog()
{
    print_section "Do you want to include Mailhog?"
    MAILHOG=$(choiceOption 'no' 'yes')
    print_success "Mailhog: $(to_upper "$MAILHOG")"

    if [ $MAILHOG = "no" ]; then
        return
    fi

    print_info "Default SMTP port for Mailhog is 1025"
    MAILHOG_SMTP_PORT=$(inputText "Default smpt port 1025" "1025")
    print_success "Mailhog SMTP port: $MAILHOG_SMTP_PORT"

    print_info "Default web port for Mailhog is 8025"
    MAILHOG_WEB_PORT=$(inputText "Default web port" "8025")
    print_success "Mailhog Web port: $MAILHOG_WEB_PORT"
}


function rabbitmq()
{
    print_section "Do you want to include RabbitMq?"
    RABBITMQ=$(choiceOption 'no' 'yes')
    print_success "RabbitMq: $(to_upper "$RABBITMQ")"

    if [ $RABBITMQ = "no" ]; then
        return
    fi

    print_info "Default port for RabbitMq is 5672"
    RABBITMQ_PORT=$(inputText "Default port 5672" "5672")
    print_success "RabbitMq port: $RABBITMQ_PORT"

    print_info "Default management port for RabbitMq is 15672"
    RABBITMQ_WEB_PORT=$(inputText "Default management port 15672" "15672")
    print_success "RabbitMq management port: $RABBITMQ_WEB_PORT"
}

function redis()
{
    print_section "Do you want to include Redis?"
    REDIS=$(choiceOption 'no' 'yes')
    print_success "Redis: $(to_upper "$REDIS")"

    if [ $REDIS = "no" ]; then
        return
    fi

    print_info "Default port for Redis is 6379"
    REDIS_PORT=$(inputText "Default port 6379" "6379")
    print_success "Redis port: $REDIS_PORT"
}
