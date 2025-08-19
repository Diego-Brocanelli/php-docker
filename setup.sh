#!/bin/bash

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variáveis globais
DOCKER_DIR=$(pwd)
PROJECT_DIR="$(dirname "$DOCKER_DIR")"
TEMPLATES_DIR="$DOCKER_DIR/templates"
GENERATED_DIR="$PROJECT_DIR"  # Gera na raiz do projeto
COMPOSE_FILES=()

# Função para exibir mensagens coloridas
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Função para fazer perguntas sim/não
ask_yes_no() {
    local question=$1
    local default=${2:-"n"}
    
    while true; do
        read -p "$question (y/n) [default: $default]: " answer
        answer=${answer:-$default}
        
        case $answer in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Por favor, responda y ou n.";;
        esac
    done
}

# Função para escolher entre opções
choose_option() {
    local prompt=$1
    shift
    local options=("$@")
    
    echo "$prompt"
    for i in "${!options[@]}"; do
        echo "$((i+1)). ${options[i]}"
    done
    
    while true; do
        read -p "Escolha uma opção (1-${#options[@]}): " choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#options[@]}" ]; then
            echo "${options[$((choice-1))]}"
            return
        else
            echo "Opção inválida. Tente novamente."
        fi
    done
}

# Função para inicializar o projeto
init_project() {
    print_message $BLUE "=== Configuração do Projeto PHP Docker ==="
    echo

    # Sempre incluir o arquivo base
    COMPOSE_FILES+=("$TEMPLATES_DIR/base/docker-compose.base.yml")
    
    # Copiar arquivo .env template para .env.docker na raiz
    cp "$TEMPLATES_DIR/base/.env.template" "$GENERATED_DIR/.env.docker"
}

# Função para configurar tipo de projeto
configure_project_type() {
    print_message $YELLOW "Tipo de Projeto:"
    project_type=$(choose_option "Selecione o tipo de projeto:" "Web (PHP + Nginx)" "CLI (PHP)")

    # Sempre adicionar PHP
    COMPOSE_FILES+=("$TEMPLATES_DIR/services/php84.yml")

    if [[ "$project_type" == "Web (PHP + Nginx)" ]]; then
        COMPOSE_FILES+=("$TEMPLATES_DIR/services/nginx.yml")
        echo "PROJECT_TYPE=web" >> "$GENERATED_DIR/.env.docker"
    else
        echo "PROJECT_TYPE=cli" >> "$GENERATED_DIR/.env.docker"
    fi

    print_message $GREEN "✓ Tipo de projeto: $project_type"
}

# Função para configurar banco de dados
configure_database() {
    print_message $YELLOW "Banco de Dados:"

    if ask_yes_no "Deseja incluir um banco de dados?"; then
        db_type=$(choose_option "Selecione o banco de dados:" "MySQL" "PostgreSQL" "MongoDB" "Nenhum")

        case $db_type in
            "MySQL")
                COMPOSE_FILES+=("$TEMPLATES_DIR/services/mysql.yml")
                echo "DATABASE_TYPE=mysql" >> "$GENERATED_DIR/.env.docker"
                ;;
            "PostgreSQL")
                COMPOSE_FILES+=("$TEMPLATES_DIR/services/postgres.yml")
                echo "DATABASE_TYPE=postgres" >> "$GENERATED_DIR/.env.docker"
                ;;
            "MongoDB")
                COMPOSE_FILES+=("$TEMPLATES_DIR/services/mongodb.yml")
                echo "DATABASE_TYPE=mongodb" >> "$GENERATED_DIR/.env.docker"
                ;;
            "Nenhum")
                echo "DATABASE_TYPE=none" >> "$GENERATED_DIR/.env.docker"
                ;;
        esac

        print_message $GREEN "✓ Banco de dados: $db_type"
    else
        echo "DATABASE_TYPE=none" >> "$GENERATED_DIR/.env.docker"
        print_message $GREEN "✓ Nenhum banco de dados selecionado"
    fi
}

# Função para configurar serviços adicionais
configure_additional_services() {
    print_message $YELLOW "Serviços Adicionais:"

    # Redis
    if ask_yes_no "Incluir Redis?"; then
        COMPOSE_FILES+=("$TEMPLATES_DIR/services/redis.yml")
        echo "REDIS_ENABLED=true" >> "$GENERATED_DIR/.env.docker"
        print_message $GREEN "✓ Redis incluído"
    else
        echo "REDIS_ENABLED=false" >> "$GENERATED_DIR/.env.docker"
    fi

    # RabbitMQ
    if ask_yes_no "Incluir RabbitMQ?"; then
        COMPOSE_FILES+=("$TEMPLATES_DIR/services/rabbitmq.yml")
        echo "RABBITMQ_ENABLED=true" >> "$GENERATED_DIR/.env.docker"
        print_message $GREEN "✓ RabbitMQ incluído"
    else
        echo "RABBITMQ_ENABLED=false" >> "$GENERATED_DIR/.env.docker"
    fi
}

# Função para gerar docker-compose final
generate_compose_file() {
    print_message $BLUE "Gerando arquivos de configuração..."
    
    # Criar comando docker-compose com todos os arquivos
    local compose_command="docker-compose"
    local compose_files_param=""
    
    for file in "${COMPOSE_FILES[@]}"; do
        if [[ -f "$file" ]]; then
            compose_files_param="$compose_files_param -f $file"
        else
            print_message $RED "Aviso: Arquivo $file não encontrado"
        fi
    done
    
    # Criar script de execução na raiz
    cat > "$GENERATED_DIR/docker-compose.sh" << EOF
#!/bin/bash
# Script gerado automaticamente pelo docker/setup.sh
# Arquivos utilizados: ${COMPOSE_FILES[*]}

# Usar o .env.docker como arquivo de ambiente
export COMPOSE_FILE="\$(echo "${COMPOSE_FILES[*]}" | sed 's| | -f |g')"
docker-compose --env-file .env.docker \$COMPOSE_FILE "\$@"
EOF

    chmod +x "$GENERATED_DIR/docker-compose.sh"

    # Gerar docker-compose.yml consolidado na raiz
    if command -v docker-compose &> /dev/null; then
        cd "$GENERATED_DIR"
        docker-compose --env-file .env.docker $compose_files_param config > docker-compose.yml 2>/dev/null || echo "# Configuração gerada pelo docker/setup.sh" > docker-compose.yml
        cd "$DOCKER_DIR"
    fi
    
    print_message $GREEN "✓ Arquivos gerados em: $GENERATED_DIR/"
}

# Função para mostrar resumo e próximos passos
show_summary() {
    echo
    print_message $BLUE "=== Resumo da Configuração ==="
    echo
    print_message $GREEN "Arquivos gerados:"
    echo "  • $GENERATED_DIR/.env"
    echo "  • $GENERATED_DIR/docker-compose.sh"
    echo "  • $GENERATED_DIR/docker-compose.yml"
    echo
    print_message $YELLOW "Próximos passos:"
    echo "  1. cd generated/"
    echo "  2. ./docker-compose.sh up -d"
    echo "  3. ./docker-compose.sh logs -f (para ver os logs)"
    echo
    print_message $GREEN "Comandos úteis:"
    echo "  • Parar: ./docker-compose.sh down"
    echo "  • Rebuild: ./docker-compose.sh up --build -d"
    echo "  • Entrar no container PHP: ./docker-compose.sh exec php bash"
    echo
}

# Função principal
main() {
    # Verificar se está no diretório correto
    if [[ ! -d "$TEMPLATES_DIR" ]]; then
        print_message $RED "Erro: Diretório templates/ não encontrado!"
        print_message $YELLOW "Execute este script no diretório docker/"
        exit 1
    fi
    
    init_project
    configure_project_type
    configure_database
    configure_additional_services
    generate_compose_file
    show_summary
}

# Executar função principal
main "$@"
