print_banner() {
    gum style \
        --foreground 212 --border-foreground 212 --border double \
        --align center --width 50 --margin "1 2" --padding "2 4" \
            'Welcome to PHP Docker' 'Starting the project setup.'
}

print_finish_banner() {
    gum style \
        --foreground 212 --border-foreground 212 --border double \
        --align center --width 50 --margin "1 2" --padding "2 4" \
            'Setup completed successfully!' 'Run "make up" to start the services.' "Main terminal commands:" " - make help - To see the available commands" " - make start - To start the services" " - make stop - To stop the services" " - make shell - To access the PHP container" " - make restart - To restart the services" " - make rebuild - To rebuild the services"  "Thank you for using PHP Docker! 🚀"
}

print_success() {
    echo -e "${NC}....${GREEN}✓ $1${NC}" >&2
}

print_info() {
    echo -e "${NC}....${CYAN}$1${NC}" >&2
}

print_error() {
    echo -e "${NC}....${RED}✗ $1${NC}" >&2
}

print() {
    echo -e "${NC}$1${NC}" >&2
}

# Nova função para quando precisar de quebra de linha antes
print_section() {
    echo -e "${CYAN}▶ $1${NC}" >&2  # Adicione >&2 aqui
}

to_lower() {
    local text="$1"
    echo "$text" | tr '[:upper:]' '[:lower:]'
}

# Converte texto para maiúsculo
to_upper() {
    local text="$1"
    echo "$text" | tr '[:lower:]' '[:upper:]'
}

to_namespace() {
    local text="$1"

    # Remove espaços e converte para PascalCase
    echo "$text" | sed 's/[^a-zA-Z0-9 ]//g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1' | sed 's/ //g'
}

# Substitui todas as ocorrências de um caractere por outro
replace_char() {
    local text="$1"
    local old_char="$2"
    local new_char="$3"
    
    if [ -z "$old_char" ]; then
        print_error "Caractere a ser substituído não informado"
        return 1
    fi
    
    echo "$text" | tr "$old_char" "$new_char"
}

replace_template_vars()
{
    local template_file="$1"
    local output_file="$2"
    local project_name="$3"
    
    # Lê o template e substitui PROJECT_NAME pelo valor real
    sed "s/PROJECT_NAME/${project_name}/g" "$template_file" > "$output_file"
    
    print_success "Config file generated: $output_file"
}
