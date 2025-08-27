#!/bin/bash

generate_env_file() {
    if [[ -f "$BASE_ENV_FILE" ]]; then  # Se arquivo existe
            rm $BASE_ENV_FILE
    fi

    touch $BASE_ENV_FILE
}

define_projetc_name() {
    while true; do
        read -p "Digite o nome do projeto: " PROJECT_NAME

        print_message $GREEN "✓ Docker Compose plugin detectado"

        if [[ -n "$PROJECT_NAME" ]]; then
            print_message $GREEN "✓ Projeto ${PROJECT_NAME}"
            break
        else
            echo "O nome do projeto não pode ser vazio. Tente novamente."
        fi
    done

    echo "# Projeto" >> "$BASE_ENV_FILE"
    echo "PROJECT_NAME=$PROJECT_NAME" >> "$BASE_ENV_FILE"
    echo "APP_ENV=development" >> "$BASE_ENV_FILE"
}

define_project_type() {
    print_message $YELLOW "Tipo de Projeto:"
    echo
    echo "Selecione o tipo de projeto:"
    echo "1. Web (PHP + Nginx)"
    echo "2. CLI (PHP)"
    echo

    # Sempre adiciona PHP independente da escolha
    COMPOSE_FILES+=("$TEMPLATES_DIR/services/php84/php84.yml")

    while true; do
        echo -n "Escolha uma opção (1-2): "
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
                print_message $RED "Opção inválida. Tente novamente."
                ;;
        esac
    done

    print_message $GREEN "✓ Tipo de projeto: $project_type"
}

# Função para configurar banco de dados
define_database() {
    print_message $YELLOW "Banco de Dados:"

    while true; do
        echo
        echo "Selecione o banco de dados desejado:"
        echo "1. MySQL"
        echo "2. PostgresSQL"
        echo "3. MongoDB"
        echo "4. Nenhum"
        echo

        echo -n "Escolha uma opção (1-4): "

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

                print_message $GREEN "✓ MySQL selecionado"

                break
                ;;
            2)   # Se PostgreSQL
                COMPOSE_FILES+=("$TEMPLATES_DIR/services/postgresql/postgreSql.yml")

                echo "" >> "$BASE_ENV_FILE"
                echo "# PostgreSQL" >> "$BASE_ENV_FILE"
                echo "POSTGRESQL_HOST=localhost" >> "$BASE_ENV_FILE"
                echo "POSTGRESQL_PORT=5432" >> "$BASE_ENV_FILE"
                echo "POSTGRESQL_DATABASE=app" >> "$BASE_ENV_FILE"
                echo "POSTGRESQL_USER=app" >> "$BASE_ENV_FILE"
                echo "POSTGRESQL_PASSWORD=app" >> "$BASE_ENV_FILE"

                print_message $GREEN "✓ PostgreSQL selecionado"

                break
                ;;
            3)      # Se MongoDB
                COMPOSE_FILES+=("$TEMPLATES_DIR/services/mongodb/mongoDb.yml")

                echo "" >> "$BASE_ENV_FILE"
                echo "# MongoDB" >> "$BASE_ENV_FILE"
                echo "MONGODB_HOST=localhost" >> "$BASE_ENV_FILE"
                echo "MONGODB_PORT=27017p" >> "$BASE_ENV_FILE"
                echo "MONGODB_USER=app" >> "$BASE_ENV_FILE"
                echo "MONGODB_PASSWORD=app" >> "$BASE_ENV_FILE"

                print_message $GREEN "✓ MongoDB selecionado"

                break
                ;;
            4) # Se nenhum
                print_message $GREEN "✓ Nenhum banco de dados selecionado"

                break
                ;;
            *) # Qualquer outra entrada
                print_message $RED "Opção inválida. Tente novamente."
                ;;
        esac
    done
}

define_additional_services() {
    print_message $YELLOW "Serviços Adicionais:"

    # Pergunta sobre Redis
    if ask_yes_no "Incluir Redis?"; then
        COMPOSE_FILES+=("$TEMPLATES_DIR/services/redis/redis.yml")

        echo "" >> "$BASE_ENV_FILE"
        echo "# Redis" >> "$BASE_ENV_FILE"
        echo "REDIS_HOST=localhost" >> "$BASE_ENV_FILE"
        echo "REDIS_PORT=6379" >> "$BASE_ENV_FILE"
        echo "REDIS_PASSWORD=app" >> "$BASE_ENV_FILE"

        print_message $GREEN "✓ Redis incluído"
    fi

    # Pergunta sobre RabbitMQ
    if ask_yes_no "Incluir RabbitMQ?"; then
        COMPOSE_FILES+=("$TEMPLATES_DIR/services/rabbitmq/rabbitMQ.yml")

        echo "" >> "$BASE_ENV_FILE"
        echo "# RabbitMQ" >> "$BASE_ENV_FILE"
        echo "RABBITMQ_HOST=localhost" >> "$BASE_ENV_FILE"
        echo "RABBITMQ_PORT=5672" >> "$BASE_ENV_FILE"
        echo "RABBITMQ_USER=app" >> "$BASE_ENV_FILE"
        echo "RABBITMQ_PASSWORD=app" >> "$BASE_ENV_FILE"
        echo "RABBITMQ_VHOST=/" >> "$BASE_ENV_FILE"

        print_message $GREEN "✓ RabbitMQ incluído"
    fi

    # Pergunta sobre MailRog
    if ask_yes_no "Incluir MailRog?"; then
        COMPOSE_FILES+=("$TEMPLATES_DIR/services/mailhog/mailHog.yml")

        echo "" >> "$BASE_ENV_FILE"
        echo "# MailRog" >> "$BASE_ENV_FILE"
        echo "MAILHOG_HOST=localhost" >> "$BASE_ENV_FILE"
        echo "MAILHOG_PORT=1025" >> "$BASE_ENV_FILE"
        echo "MAILHOG_WEB_PORT=8025" >> "$BASE_ENV_FILE"

        print_message $GREEN "✓ MailHog incluído"
    fi
}
