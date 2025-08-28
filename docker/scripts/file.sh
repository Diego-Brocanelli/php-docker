#!/bin/bash

clear_env_base_file() {
    if [[ -f "$BASE_ENV_FILE" ]]; then
        rm $BASE_ENV_FILE
    fi

    print_success "✓ Arquivo .env.docker criado com sucesso"

    touch $BASE_ENV_FILE
}

generate_env_file() {
    if [[ ! -f "$BASE_ENV_FILE" ]]; then
        print_error "❌ Erro: Arquivo '$BASE_ENV_FILE' não encontrado!"

        exit 1
    fi

    cp -f $BASE_ENV_FILE $PROJECT_DIR/.env

    print_empty_line
    print_warning "Gerando arquivo ,env"
    print_success "    ✓ Arquivo .env gerado com sucesso"
}

generate_compose_file() {
    print_empty_line
    print_warning "Gerando arquivo compose.yml"

    # Inicializa variável para parâmetros do comando compose
    local compose_files_param=""

    # Loop através de todos os arquivos compose coletados
    for file in "${COMPOSE_FILES[@]}"; do
        if [[ -f "$file" ]]; then  # Se arquivo existe
            compose_files_param="$file"
        else
            # Se arquivo não existe, exibe aviso
            print_error "Aviso: Arquivo $file não encontrado"
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

        print_empty_line
        print_success "  ✓ Arquivo compose.yml consolidado gerado"  # Sucesso
    else
        print_empty_line
        print_warning "  ⚠ Arquivo consolidado não pôde ser gerado!"
    fi
}
