check_empty() {
    local value="$1"
    local field_name="${2:-Campo}"
    local default_value="${3:-}"

    if [ -z "$value" ]; then
        if [ -n "$default_value" ]; then
            echo $default_value

            return 0
        fi

        print_error "$field_name não pode ser vazio"

        return 1
    fi

    return 0
}

file_exists() {
    local file_path="$1"
    local description="${2:-O arquivo}"  # Descrição do arquivo (opcional)

    if [ ! -f "$file_path" ]; then
        print_error "$description não encontrado em: $file_path"

        return 1
    fi

    return 0
}
