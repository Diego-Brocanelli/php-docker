#!/usr/bin/env bash

# Letra inicial, depois letras, números, espaço, _ ou -. Máx. 50 caracteres.
is_valid_project_name() {
    [[ "$1" =~ ^[A-Za-z][A-Za-z0-9\ _-]{0,49}$ ]]
}

# Identificadores de banco: nome e usuário
is_valid_identifier() {
    [[ "$1" =~ ^[A-Za-z_][A-Za-z0-9_]{0,62}$ ]]
}

# Senha: apenas letras, números e . _ ~ ! * + = , -
# (outros caracteres quebram a interpolação no .env/compose ou URIs como MONGODB_URI)
is_valid_password() {
    [[ "$1" =~ ^[A-Za-z0-9._~!*+=,-]+$ ]]
}

# Timezone IANA, ex.: America/Sao_Paulo. Confere em /usr/share/zoneinfo quando existir.
is_valid_timezone() {
    local tz="$1"

    [[ "$tz" =~ ^[A-Za-z0-9_+-]+(/[A-Za-z0-9_+-]+)*$ ]] || return 1

    if [[ -d /usr/share/zoneinfo ]]; then
        [[ -f "/usr/share/zoneinfo/$tz" ]]
    fi
}

is_yes_no() {
    [[ "$1" == "yes" || "$1" == "no" ]]
}

is_valid_port() {
    local port="$1"

    [[ "$port" =~ ^[0-9]{1,5}$ ]] || return 1
    (( 10#$port >= 1 && 10#$port <= 65535 ))
}

is_port_used() {
    local port="$1"
    local used

    for used in "${USED_PORTS[@]}"; do
        [[ "$used" == "$port" ]] && return 0
    done

    return 1
}

file_exists() {
    local file_path="$1"
    local description="${2:-File}"

    if [[ ! -f "$file_path" ]]; then
        print_error "$description not found: $file_path"

        return 1
    fi

    return 0
}
