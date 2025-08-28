#!/bin/bash

check_docker_compose() {
    # Verifica se comando 'docker' existe no PATH
    if ! command -v docker &> /dev/null; then
        print_error "Erro: Docker não está instalado ou não está no PATH"
        exit 1
    fi
    
    # Verifica se plugin 'docker compose' funciona
    if ! docker compose version &> /dev/null; then
        print_error "Erro: Docker Compose plugin não está disponível"
        print_warning "Certifique-se de que o Docker Compose plugin está instalado"
        exit 1
    fi
    
    print_success "✓ Docker Compose plugin detectado"  # Sucesso em verde
}

check_make() {
    # Verifica se comando 'make' existe no PATH
    if ! command -v make &> /dev/null; then
        print_error "Erro: Make não está instalado ou não está no PATH"
        print_warning "Instale o Make para facilitar o uso dos comandos"
        exit 1
    fi
    
    print_success "✓ Make detectado"  # Sucesso em verde
}   
