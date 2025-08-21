#!/bin/bash

# Função para exibir mensagens coloridas no terminal
print_message() {
    local color=$1        # Primeiro parâmetro: código da cor
    local message=$2      # Segundo parâmetro: texto da mensagem
    echo -e "${color}${message}${NC}"  # Imprime mensagem com cor e reseta cor ao final
}

# Função para fazer perguntas com resposta sim/não
ask_yes_no() {
    local question=$1           # Primeiro parâmetro: pergunta a ser feita
    local default=${2:-"n"}     # Segundo parâmetro: valor padrão (default é "n" se não fornecido)
    
    while true; do              # Loop infinito até resposta válida
        # Exibe pergunta com opções e valor padrão
        read -p "$question (y/n) [default: $default]: " answer
        answer=${answer:-$default}  # Se resposta vazia, usa valor padrão
        
        case $answer in         # Avalia resposta do usuário
            [Yy]* ) return 0;;  # Y ou y ou Yes: retorna 0 (sucesso)
            [Nn]* ) return 1;;  # N ou n ou No: retorna 1 (falha) 
            * ) echo "Por favor, responda y ou n.";;  # Qualquer outra coisa: repete pergunta
        esac
    done
}

# Função para escolher entre múltiplas opções (versão original com command substitution)
choose_option() {
    local prompt=$1       # Primeiro parâmetro: texto do prompt
    shift                 # Remove primeiro parâmetro, deixa só as opções
    local options=("$@")  # Todos os parâmetros restantes viram array de opções
    
    echo                  # Linha em branco para espaçamento
    echo "$prompt"        # Exibe o texto do prompt
    echo                  # Outra linha em branco
    
    # Loop para exibir cada opção numerada
    for i in "${!options[@]}"; do               # Itera sobre índices do array
        printf "%d. %s\n" "$((i+1))" "${options[i]}"  # Imprime "1. Opção1", "2. Opção2", etc
    done
    echo                  # Linha em branco após opções
    
    while true; do        # Loop até escolha válida
        # Exibe prompt com range de opções válidas
        printf "Escolha uma opção (1-%d): " "${#options[@]}"
        read choice       # Lê entrada do usuário
        
        # Remove todos os espaços em branco da escolha
        choice=$(echo "$choice" | tr -d '[:space:]')
        
        # Valida se entrada é número e está no range correto
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#options[@]}" ]; then
            echo "${options[$((choice-1))]}"  # Retorna opção escolhida (índice-1 pois array começa em 0)
            return 0      # Sai da função com sucesso
        else
            print_message $RED "Opção inválida. Tente novamente."  # Mensagem de erro em vermelho
            echo          # Linha em branco
        fi
    done
}

#!/bin/bash

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

# Função que converte string para lowercase
# RESULT=$(to_lower "HELLO WORLD")
# echo "$RESULT"   # hello world
to_lower() {
    local input="$1"
    # Converte para minúsculas usando Bash moderno
    echo "${input,,}"
}

