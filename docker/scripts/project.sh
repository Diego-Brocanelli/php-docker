#!/bin/bash

define_projetc_name() {
    while true; do
        read -p "Digite o nome do projeto: " PROJECT_NAME

        print_message $GREEN "✓ Docker Compose plugin detectado"

        if [[ -n "$PROJECT_NAME" ]]; then
            print_message $GREEN "✓ Projeto ${PROJECT_NAME}"

            break
        else
            print_warning "O nome do projeto não pode ser vazio. Tente novamente."
        fi
    done

    print_text "# Projeto" >> "$BASE_ENV_FILE"
    print_text "PROJECT_NAME=$PROJECT_NAME" >> "$BASE_ENV_FILE"
    print_text "APP_ENV=development" >> "$BASE_ENV_FILE"
}

define_project_type() {
    print_empty_line
    
    print_warning "Tipo de Projeto:"
    
    print_text "Selecione o tipo de projeto:"
    print_text "  1. Web (PHP + Nginx)"
    print_text "  2. CLI (PHP)"

    # Sempre adiciona PHP independente da escolha
    COMPOSE_FILES+=("$TEMPLATES_DIR/services/php84/php84.yml")

    while true; do
        print_text -n "Escolha uma opção (1-2): "

        read choice
        
        case $choice in
            1) # Se escolheu 1
                project_type="Web (PHP + Nginx)"

                COMPOSE_FILES+=("$TEMPLATES_DIR/services/nginx/nginx.yml")

                echo "PROJECT_TYPE=web" >> "$BASE_ENV_FILE"

                rm -rf "$TEMPLATES_DIR/services/nginx/config/config.conf"

                cp -f "$CONFIG_BASE_NGINX" "$TEMPLATES_DIR/services/nginx/config/config.conf"

                replace_variable "PROJECT_NAME" "${PROJECT_NAME}_php" "$TEMPLATES_DIR/services/nginx/config/config.conf"

                break
                ;;
            2) # Se escolheu 2
                project_type="CLI (PHP)"

                echo "PROJECT_TYPE=cli" >> "$BASE_ENV_FILE"

                break
                ;;
            *) # Qualquer outra entrada
                print_error "Opção inválida. Tente novamente."
                ;;
        esac
    done

    print_success "✓ Tipo de projeto: $project_type"
}

# Função para configurar banco de dados
define_database() {
    print_empty_line
    print_warning "Banco de Dados:"

    while true; do
        print_empty_line
        print_info "Selecione o banco de dados desejado:"
        print_text "  1. MySQL"
        print_text "  2. MariaDB"
        print_text "  3. PostgresSQL"
        print_text "  4. MongoDB"
        print_text "  5. Nenhum"

        print_text -n "Escolha uma opção (1-5): "

        read choice

        case $choice in
            1) # Se MySQL
                COMPOSE_FILES+=("$TEMPLATES_DIR/services/mysql/mysql.yml")

                echo "" >> "$BASE_ENV_FILE"
                echo "# MySQL" >> "$BASE_ENV_FILE"
                echo "MYSQL_HOST=localhost" >> "$BASE_ENV_FILE"
                echo "MYSQL_PORT=3306" >> "$BASE_ENV_FILE"
                echo "MYSQL_DATABASE=app" >> "$BASE_ENV_FILE"
                echo "MYSQL_USER=app" >> "$BASE_ENV_FILE"
                echo "MYSQL_PASSWORD=app" >> "$BASE_ENV_FILE"
                echo "MYSQL_ROOT_PASSWORD=root" >> "$BASE_ENV_FILE"

                print_success "✓ MySQL selecionado"

                break
                ;;
            2)   # Se MariaDB
                COMPOSE_FILES+=("$TEMPLATES_DIR/services/mariadb/mariadb.yml")

                echo "" >> "$BASE_ENV_FILE"
                echo "# MariaDB" >> "$BASE_ENV_FILE"
                echo "MARIADB_HOST=localhost" >> "$BASE_ENV_FILE"
                echo "MARIADB_PORT=33006" >> "$BASE_ENV_FILE"
                echo "MARIADB_DATABASE=app" >> "$BASE_ENV_FILE"
                echo "MARIADB_USER=app" >> "$BASE_ENV_FILE"
                echo "MARIADB_PASSWORD=app" >> "$BASE_ENV_FILE"

                print_success "✓ MariaDB selecionado"

                break
                ;;
            3)   # Se PostgreSQL
                COMPOSE_FILES+=("$TEMPLATES_DIR/services/postgresql/postgreSql.yml")

                echo "" >> "$BASE_ENV_FILE"
                echo "# PostgreSQL" >> "$BASE_ENV_FILE"
                echo "POSTGRESQL_HOST=localhost" >> "$BASE_ENV_FILE"
                echo "POSTGRESQL_PORT=5432" >> "$BASE_ENV_FILE"
                echo "POSTGRESQL_DATABASE=app" >> "$BASE_ENV_FILE"
                echo "POSTGRESQL_USER=app" >> "$BASE_ENV_FILE"
                echo "POSTGRESQL_PASSWORD=app" >> "$BASE_ENV_FILE"

                print_success "✓ PostgreSQL selecionado"

                break
                ;;
            4)      # Se MongoDB
                COMPOSE_FILES+=("$TEMPLATES_DIR/services/mongodb/mongoDb.yml")

                echo "" >> "$BASE_ENV_FILE"
                echo "# MongoDB" >> "$BASE_ENV_FILE"
                echo "MONGODB_HOST=localhost" >> "$BASE_ENV_FILE"
                echo "MONGODB_PORT=27017p" >> "$BASE_ENV_FILE"
                echo "MONGODB_USER=app" >> "$BASE_ENV_FILE"
                echo "MONGODB_PASSWORD=app" >> "$BASE_ENV_FILE"

                print_success "✓ MongoDB selecionado"

                break
                ;;
            5) # Se nenhum
                print_success "✓ Nenhum banco de dados selecionado"

                break
                ;;
            *) # Qualquer outra entrada
                print_error "Opção inválida. Tente novamente."
                ;;
        esac
    done
}

define_additional_services() {
    print_empty_line
    print_warning "Serviços Adicionais:"

    # Pergunta sobre Redis
    if ask_yes_no "  Incluir Redis?"; then
        COMPOSE_FILES+=("$TEMPLATES_DIR/services/redis/redis.yml")

        echo "" >> "$BASE_ENV_FILE"
        echo "# Redis" >> "$BASE_ENV_FILE"
        echo "REDIS_HOST=localhost" >> "$BASE_ENV_FILE"
        echo "REDIS_PORT=6379" >> "$BASE_ENV_FILE"
        echo "REDIS_PASSWORD=app" >> "$BASE_ENV_FILE"

        print_success "  ✓ Redis incluído"
    fi

    # Pergunta sobre RabbitMQ
    if ask_yes_no "  Incluir RabbitMQ?"; then
        COMPOSE_FILES+=("$TEMPLATES_DIR/services/rabbitmq/rabbitMQ.yml")

        echo "" >> "$BASE_ENV_FILE"
        echo "# RabbitMQ" >> "$BASE_ENV_FILE"
        echo "RABBITMQ_HOST=localhost" >> "$BASE_ENV_FILE"
        echo "RABBITMQ_PORT=5672" >> "$BASE_ENV_FILE"
        echo "RABBITMQ_USER=app" >> "$BASE_ENV_FILE"
        echo "RABBITMQ_PASSWORD=app" >> "$BASE_ENV_FILE"
        echo "RABBITMQ_VHOST=/" >> "$BASE_ENV_FILE"

        print_success "  ✓ RabbitMQ incluído"
    fi

    # Pergunta sobre MailRog
    if ask_yes_no "  Incluir MailRog?"; then
        COMPOSE_FILES+=("$TEMPLATES_DIR/services/mailhog/mailHog.yml")

        echo "" >> "$BASE_ENV_FILE"
        echo "# MailRog" >> "$BASE_ENV_FILE"
        echo "MAILHOG_HOST=localhost" >> "$BASE_ENV_FILE"
        echo "MAILHOG_PORT=1025" >> "$BASE_ENV_FILE"
        echo "MAILHOG_WEB_PORT=8025" >> "$BASE_ENV_FILE"

        print_success "  ✓ MailHog incluído"
    fi
}
