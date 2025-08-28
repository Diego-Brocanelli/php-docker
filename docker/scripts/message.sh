#!/bin/bash

# Função para exibir mensagens coloridas no terminal
print_message() {
    local color=$1        # Primeiro parâmetro: código da cor
    local message=$2      # Segundo parâmetro: texto da mensagem
    echo -e "${color}${message}${NC}"  # Imprime mensagem com cor e reseta cor ao final
}

print_empty_line() {
    echo ""
}

print_text() {
    local message=$1
    echo -e "${message}"
}

print_error() {
    local message=$1
    print_message $RED "$message"
}

print_warning() {
    local message=$1
    print_message $YELLOW "$message"
}

print_success() {
    local message=$1
    print_message $GREEN "$message"
}

print_info() {
    local message=$1
    print_message $BLUE "$message"
}

# Função para substituir variáveis em um arquivo
# Uso: replace_variable "NOME_DA_VARIAVEL" "TEXTO_SUBSTITUTO" "CAMINHO_DO_ARQUIVO"
replace_variable() {
    local var_name="$1"
    local replacement="$2"
    local file="$3"

    # Verifica se o arquivo existe
    if [[ ! -f "$file" ]]; then
        echo "Erro: Arquivo '$file' não encontrado!"
        return 1
    fi

    # Substitui a variável usando sed
    sed -i "s|$var_name|$replacement|g" "$file"
}
