#!/bin/bash

source "./variables.sh"
source "./message.sh"
source "./file.sh"
source "./form.sh"
source "./validation.sh"
source "./project.sh"

# Função para inicializar configuração do projeto
init_project() {
    # Exibe título principal em azul
    print_info "=== 🔧 Configurando ambiente Docker    ==="
    print_info "=== Configuração do Projeto PHP Docker ==="

    print_empty_line

    check_docker_compose

    check_make

    # Adiciona arquivo base obrigatório ao array de arquivos compose
    COMPOSE_FILES+=("$TEMPLATES_DIR/base/compose.base.yml")
}

show_summary() {
    print_empty_line
    
    print_warning "Arquivos gerados:" # Subtítulo
    
    print_text "  • $PROJECT_DIR/.env"
    print_text "  • $PROJECT_DIR/compose.yml"
    
    print_empty_line
    
    print_warning "Comandos úteis:"   # Lista de comandos úteis
    print_text "  • make up            Build"
    print_text "  • make down          Para os conataineres"
    print_text "  • make exec php bash Entrar no container PHP"
    print_text "  • make ps            Ver status"
    print_text "  • make logs          Ver logs"

    print_empty_line
    
    print_success "Setup finalizado com sucesso! 🚀"
    print_success "Obrigado por usar PHP Docker :) "
}

main() {
    init_project               # Inicialização
    clear_env_base_file        # Limpa o arquivo base .env.docker
    define_projetc_name        # Define o nome do projeto e inclue no arquivo docker/templates/configs/nginx/default.conf
    define_project_type        # Define o tipo de projeto e inclue no arquivo docker/templates/configs/.env.docker
    define_database            # Define o bando de dados e inclue no arquivo docker/templates/configs/.env.docker
    define_additional_services # Define se usará Redis e/ou RabbitMq e inclue no arquivo docker/templates/configs/.env.docker
    generate_env_file          # Executa a finalização do script (copy .env)
    generate_compose_file      # Gera na raiz do projeto o arquivo compose.yml consolidado
    replace_variable $PROJECT_DIR "." "$PROJECT_DIR/compose.yml"
    clear_env_base_file        # Limpa o arquivo base .env.docker
    show_summary               # Mostrar resumo
}

main "$@"
