#!/usr/bin/env bash

# define_project_name ["<padrão>"]
define_project_name() {
    local default_value="${1:-}"
    local name

    while true; do
        name="$(inputText "Project name" "$default_value")"

        if is_valid_project_name "$name"; then
            printf '%s' "$name"
            return 0
        fi

        print_error "Invalid name: start with a letter; use letters, numbers, spaces, _ or - (max. 50)"
        (( NON_INTERACTIVE )) && exit 1
    done
}
