#!/usr/bin/env bash

# Desenha uma caixa com as linhas recebidas, centralizadas
print_box() {
    local width=54
    local line pad_left pad_right
    local border
    border="$(printf '═%.0s' $(seq 1 "$width"))"

    printf '\n%s╔%s╗%s\n' "$MAGENTA" "$border" "$NC" >&2
    printf '%s║%*s║%s\n' "$MAGENTA" "$width" '' "$NC" >&2
    for line in "$@"; do
        if (( ${#line} > width - 2 )); then
            line="${line:0:width-2}"
        fi
        pad_left=$(( (width - ${#line}) / 2 ))
        pad_right=$(( width - ${#line} - pad_left ))
        printf '%s║%*s%s%*s║%s\n' "$MAGENTA" "$pad_left" '' "$line" "$pad_right" '' "$NC" >&2
    done
    printf '%s║%*s║%s\n' "$MAGENTA" "$width" '' "$NC" >&2
    printf '%s╚%s╝%s\n\n' "$MAGENTA" "$border" "$NC" >&2
}

print_banner() {
    print_box 'Welcome to PHP Docker' 'Starting the project setup.'
}

print_finish_banner() {
    print_box \
        'Setup completed successfully!' \
        '' \
        'Main terminal commands:' \
        'make help    - Show the available commands' \
        'make start   - Start the services' \
        'make stop    - Stop the services' \
        'make shell   - Access the PHP container' \
        'make restart - Restart the services' \
        'make rebuild - Rebuild the services' \
        '' \
        'Thank you for using PHP Docker!'
}

print_success() {
    printf '%s....%s✓ %s%s\n' "$NC" "$GREEN" "$1" "$NC" >&2
}

print_info() {
    printf '%s....%s%s%s\n' "$NC" "$CYAN" "$1" "$NC" >&2
}

print_warning() {
    printf '%s....%s! %s%s\n' "$NC" "$YELLOW" "$1" "$NC" >&2
}

print_error() {
    printf '%s....%s✗ %s%s\n' "$NC" "$RED" "$1" "$NC" >&2
}

print_section() {
    printf '\n%s%s▶ %s%s\n' "$BOLD" "$CYAN" "$1" "$NC" >&2
}

to_lower() {
    printf '%s' "${1,,}"
}

to_upper() {
    printf '%s' "${1^^}"
}

# "my cool-app" -> "MyCoolApp"
to_namespace() {
    local text="$1"
    local word first rest result=""

    text="${text//[^a-zA-Z0-9]/ }"
    for word in $text; do
        first="${word:0:1}"
        rest="${word:1}"
        result+="${first^^}${rest,,}"
    done

    # Namespace PHP não pode começar com número
    if [[ "$result" =~ ^[0-9] ]]; then
        result="App$result"
    fi

    printf '%s' "$result"
}

# "My Cool-App" -> "my_cool_app"
to_snake_case() {
    local text="${1,,}"

    text="${text//[^a-z0-9]/_}"
    while [[ "$text" == *__* ]]; do
        text="${text//__/_}"
    done
    text="${text#_}"
    text="${text%_}"

    printf '%s' "$text"
}
