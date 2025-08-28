#!/bin/bash

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
            * ) print_warning "Por favor, responda y ou n.";;  # Qualquer outra coisa: repete pergunta
        esac
    done
}

choose_option() {
    local prompt=$1       # Primeiro parâmetro: texto do prompt
    shift                 # Remove primeiro parâmetro, deixa só as opções
    local options=("$@")  # Todos os parâmetros restantes viram array de opções
    
    print_empty_line
    print_text "$prompt"
    print_empty_line
    
    # Loop para exibir cada opção numerada
    for i in "${!options[@]}"; do               # Itera sobre índices do array
        printf "%d. %s\n" "$((i+1))" "${options[i]}"  # Imprime "1. Opção1", "2. Opção2", etc
    done

    print_empty_line
    
    while true; do        # Loop até escolha válida
        # Exibe prompt com range de opções válidas
        printf "Escolha uma opção (1-%d): " "${#options[@]}"
        read choice       # Lê entrada do usuário
        
        # Remove todos os espaços em branco da escolha
        choice=$(print_text "$choice" | tr -d '[:space:]')
        
        # Valida se entrada é número e está no range correto
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#options[@]}" ]; then
            print_text "${options[$((choice-1))]}"  # Retorna opção escolhida (índice-1 pois array começa em 0)
            return 0      # Sai da função com sucesso
        else
            print_message $RED "Opção inválida. Tente novamente."  # Mensagem de erro em vermelho
            print_empty_line          # Linha em branco
        fi
    done
}
