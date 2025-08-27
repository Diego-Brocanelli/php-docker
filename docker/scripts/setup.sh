#!/bin/bash

source "./variables.sh"
source "./message.sh"
source "./project.sh"

check_docker_compose() {
    # Verifica se comando 'docker' existe no PATH
    if ! command -v docker &> /dev/null; then
        print_message $RED "Erro: Docker não está instalado ou não está no PATH"
        exit 1        # Termina script com código de erro
    fi
    
    # Verifica se plugin 'docker compose' funciona
    if ! docker compose version &> /dev/null; then
        print_message $RED "Erro: Docker Compose plugin não está disponível"
        print_message $YELLOW "Certifique-se de que o Docker Compose plugin está instalado"
        exit 1        # Termina script com código de erro
    fi
    
    print_message $GREEN "✓ Docker Compose plugin detectado"  # Sucesso em verde
}

# Função para inicializar configuração do projeto
init_project() {
    # Exibe título principal em azul
    print_message $BLUE "=== Configuração do Projeto PHP Docker ==="
    echo              # Linha em branco

    # Chama verificação de dependências
    check_docker_compose

    # Adiciona arquivo base obrigatório ao array de arquivos compose
    COMPOSE_FILES+=("$TEMPLATES_DIR/base/compose.base.yml")
}

generate_compose_file() {
    print_message $BLUE "Gerando arquivo compose.yml"  # Título da etapa

    # Inicializa variável para parâmetros do comando compose
    local compose_files_param=""

    # Loop através de todos os arquivos compose coletados
    for file in "${COMPOSE_FILES[@]}"; do
        if [[ -f "$file" ]]; then  # Se arquivo existe
            compose_files_param="$file"
        else
            # Se arquivo não existe, exibe aviso
            print_message $RED "Aviso: Arquivo $file não encontrado"
        fi
    done

    # Inicializa variável para parâmetros do config
    local files_for_config=""
    # Loop similar ao anterior para montar comando config
    for file in "${COMPOSE_FILES[@]}"; do
        if [[ -f "$file" ]]; then  # Se arquivo existe
            # Calcula caminho relativo
            local relative_path="$file"
            # Adiciona ao parâmetro
            files_for_config="$files_for_config -f $relative_path"
        fi
    done

    # Tenta gerar arquivo compose.yml consolidado
    if docker compose --env-file $PROJECT_DIR/.env $files_for_config config > $PROJECT_DIR/compose.yml; then
        # o arquivo é consolidato com o caminho completo, removo para ficar relativo.
        PARENT_DIR="${PWD}" # Guarda o diretório pai
        sed -i "s|$PARENT_DIR|.|g" $PROJECT_DIR/compose.yml

        print_message $GREEN "********************************"  # Sucesso
        print_message $GREEN "✓ Arquivo compose.yml consolidado gerado"  # Sucesso
    else
        print_message $YELLOW "*****************************************************************"
        print_message $YELLOW "⚠ Arquivo consolidado não pôde ser gerado!"
    fi

    print_message $GREEN "✓ Arquivos gerados"
}

generate_env_file() {
    if [[ ! -f "$BASE_ENV_FILE" ]]; then
        print_message $RED "❌ Erro: Arquivo '$BASE_ENV_FILE' não encontrado!"

        exit 1
    fi

    cp -f $BASE_ENV_FILE $PROJECT_DIR/.env
    print_message $GREEN "✓ Arquivo .env copiado com sucesso"
}

show_summary() {
    echo
    print_message $BLUE "=============================="
    print_message $BLUE "=== Resumo da Configuração ==="
    print_message $BLUE "=============================="
    echo
    print_message $YELLOW "Arquivos gerados:" # Subtítulo
    # Lista os arquivos gerados com seus caminhos completos
    print_message $GREEN "  • $PROJECT_DIR/.env"
    print_message $GREEN "  • $PROJECT_DIR/compose.yml"
    echo
    print_message $YELLOW "Comandos úteis:"   # Lista de comandos úteis
    print_message $GREEN "  • make up            Build"
    print_message $GREEN "  • make down          Para os conataineres"
    print_message $GREEN "  • make exec php bash Entrar no container PHP"
    print_message $GREEN "  • make ps            Ver status"
    print_message $GREEN "  • make logs          Ver logs"
    echo
}

main() {
    init_project               # 1. Inicialização
    generate_env_file          # 2. Recria o arquivo base
    define_projetc_name        # 3. Define o nome do projeto e inclue no arquivo docker/templates/configs/nginx/default.conf
    define_project_type        # 4. Define o tipo de projeto e inclue no arquivo docker/templates/configs/.env.docker
    define_database            # 5. Define o bando de dados e inclue no arquivo docker/templates/configs/.env.docker
    define_additional_services # 6. Define se usará Redis e/ou RabbitMq e inclue no arquivo docker/templates/configs/.env.docker
    generate_env_file          # 7. Executa a finalização do script (copy .env)
    generate_compose_file      # 8. Gera na raiz do projeto o arquivo compose.yml consolidado
    replace_variable $PROJECT_DIR "." "$PROJECT_DIR/compose.yml"
    show_summary               # 9. Mostrar resumo
}

main "$@"
