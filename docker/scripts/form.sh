#!/usr/bin/env bash
#
# Entrada interativa em bash puro (sem dependências externas).
# Todas as funções escrevem o prompt em stderr e o valor escolhido em stdout,
# para serem usadas com VAR=$(funcao ...).
#
# Com NON_INTERACTIVE=1 (flag --yes) nenhuma pergunta é feita: os valores padrão são usados.
NON_INTERACTIVE="${NON_INTERACTIVE:-0}"

# Lê uma linha da entrada. Encerra o setup se a entrada terminar (EOF/Ctrl+D).
read_line() {
    local __line

    if ! IFS= read -r __line; then
        printf '\n' >&2
        print_error "Input closed. Setup aborted."
        exit 1
    fi

    printf '%s' "$__line"
}

# inputText "<label>" ["<default>"]
inputText() {
    local label="$1"
    local default_value="${2:-}"
    local value

    if (( NON_INTERACTIVE )); then
        printf '%s' "$default_value"
        return 0
    fi

    if [[ -n "$default_value" ]]; then
        printf '  %s [%s]: ' "$label" "$default_value" >&2
    else
        printf '  %s: ' "$label" >&2
    fi

    value="$(read_line)"
    printf '%s' "${value:-$default_value}"
}

# inputSecret "<label>" ["<default>"] ["<dica>"] - não ecoa o que é digitado
inputSecret() {
    local label="$1"
    local default_value="${2:-}"
    local hint="${3:-$default_value}"
    local value

    if (( NON_INTERACTIVE )); then
        printf '%s' "$default_value"
        return 0
    fi

    if [[ -n "$default_value" ]]; then
        printf '  %s [%s]: ' "$label" "$hint" >&2
    else
        printf '  %s: ' "$label" >&2
    fi

    if [[ -t 0 ]]; then
        stty -echo 2>/dev/null || true
        value="$(read_line)" || { stty echo 2>/dev/null; exit 1; }
        stty echo 2>/dev/null || true
        printf '\n' >&2
    else
        value="$(read_line)"
    fi

    printf '%s' "${value:-$default_value}"
}

# choiceOption "<opção padrão>" "<opção 2>" ... - menu numerado
choiceOption() {
    local options=("$@")
    local total=${#options[@]}
    local i answer

    if (( NON_INTERACTIVE )); then
        printf '%s' "${options[0]}"
        return 0
    fi

    for i in "${!options[@]}"; do
        if (( i == 0 )); then
            printf '  %d) %s %s(default)%s\n' "$(( i + 1 ))" "${options[$i]}" "$YELLOW" "$NC" >&2
        else
            printf '  %d) %s\n' "$(( i + 1 ))" "${options[$i]}" >&2
        fi
    done

    while true; do
        printf '  Choose [1-%d]: ' "$total" >&2
        answer="$(read_line)"
        answer="${answer:-1}"

        if [[ "$answer" =~ ^[0-9]+$ ]] && (( 10#$answer >= 1 && 10#$answer <= total )); then
            printf '%s' "${options[$(( 10#$answer - 1 ))]}"
            return 0
        fi

        # Aceita também o texto da opção
        for i in "${!options[@]}"; do
            if [[ "${options[$i]}" == "$answer" ]]; then
                printf '%s' "$answer"
                return 0
            fi
        done

        print_error "Invalid option: $answer"
    done
}

# multiChoice "<opção 1>" "<opção 2>" ... - várias opções separadas por espaço ou vírgula.
# Imprime os índices escolhidos (base 0) separados por espaço; Enter = nenhuma.
multiChoice() {
    local options=("$@")
    local total=${#options[@]}
    local i answer number valid
    local -a picked

    if (( NON_INTERACTIVE )); then
        return 0
    fi

    for i in "${!options[@]}"; do
        printf '  %2d) %s\n' "$(( i + 1 ))" "${options[$i]}" >&2
    done

    while true; do
        printf '  Choose one or more (e.g. 1 3 5), Enter for none: ' >&2
        answer="$(read_line)"
        answer="${answer//,/ }"
        picked=()
        valid=1

        for number in $answer; do
            if [[ ! "$number" =~ ^[0-9]+$ ]] || (( 10#$number < 1 || 10#$number > total )); then
                print_error "Invalid option: $number (use 1-$total)"
                valid=0
                break
            fi
            number=$(( 10#$number - 1 ))
            [[ " ${picked[*]} " == *" $number "* ]] || picked+=("$number")
        done

        if (( valid )); then
            printf '%s' "${picked[*]}"
            return 0
        fi
    done
}

# confirm "<pergunta>" -> retorna 0 para sim (padrão: não)
confirm() {
    local question="$1"
    local answer

    if (( NON_INTERACTIVE )); then
        return 0
    fi

    printf '  %s [y/N]: ' "$question" >&2
    answer="$(read_line)"

    [[ "${answer,,}" == "y" || "${answer,,}" == "yes" || "${answer,,}" == "s" || "${answer,,}" == "sim" ]]
}

# inputPort "<label>" "<default>" - valida faixa e conflito com portas já usadas
inputPort() {
    local label="$1"
    local default_value="$2"
    local port

    while true; do
        port="$(inputText "$label" "$default_value")"

        if ! is_valid_port "$port"; then
            print_error "Invalid port: '$port' (use 1-65535)"
            (( NON_INTERACTIVE )) && exit 1
            continue
        fi

        port="$(( 10#$port ))"

        if is_port_used "$port"; then
            print_error "Port $port is already used by another service"
            (( NON_INTERACTIVE )) && exit 1
            continue
        fi

        printf '%s' "$port"
        return 0
    done
}

# inputIdentifier "<label>" "<default>" - nome de banco/usuário
inputIdentifier() {
    local label="$1"
    local default_value="$2"
    local value

    while true; do
        value="$(inputText "$label" "$default_value")"

        if is_valid_identifier "$value"; then
            printf '%s' "$value"
            return 0
        fi

        print_error "Invalid value: use only letters, numbers and _ (max. 63)"
        (( NON_INTERACTIVE )) && exit 1
    done
}

# inputPassword "<label>" ["<padrão>"] - Enter usa o padrão; sem padrão, gera uma senha aleatória
inputPassword() {
    local label="$1"
    local default_value="${2:-}"
    local value

    while true; do
        if [[ -n "$default_value" ]]; then
            value="$(inputSecret "$label" "$default_value")"
        else
            value="$(inputSecret "$label" "$(generate_password)" "Enter = generate a random one")"
        fi

        if is_valid_password "$value"; then
            printf '%s' "$value"
            return 0
        fi

        print_error "Invalid password: use only letters, numbers and . _ ~ ! * + = , -"
        (( NON_INTERACTIVE )) && exit 1
    done
}

generate_password() {
    local password

    password="$(LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 24 || true)"
    printf '%s' "$password"
}
