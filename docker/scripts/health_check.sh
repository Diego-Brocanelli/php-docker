#!/usr/bin/env bash

check_dependency() {
    local failed=0

    print_section "Checking dependencies..."

    if (( BASH_VERSINFO[0] > 4 || (BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] >= 4) )); then
        print_success "Bash $BASH_VERSION"
    else
        print_error "Bash 4.4+ is required (current: $BASH_VERSION)"
        failed=1
    fi

    if check_command "docker" "Docker"; then
        if docker compose version &>/dev/null; then
            print_success "Docker Compose v2 is installed"
        else
            print_error "Docker Compose v2 (docker compose) is not installed"
            print_info "See: https://docs.docker.com/compose/install/linux/"
            failed=1
        fi

        if docker info &>/dev/null; then
            print_success "Docker daemon is reachable"
        else
            print_error "Unable to reach the Docker daemon"
            print_info "Start Docker and make sure your user can run it (group 'docker' or rootless)"
            failed=1
        fi
    else
        print_info "Please install Docker: https://docs.docker.com/engine/install/"
        failed=1
    fi

    if ! check_command "make" "Make"; then
        print_info "Install 'make' with your distribution's package manager"
        failed=1
    fi

    if (( failed )); then
        exit 1
    fi

    print_success "All the dependencies are installed!"
}

# check_command "<comando>" ["<nome amigável>"]
check_command() {
    local cmd="$1"
    local name="${2:-$1}"

    if command -v "$cmd" &>/dev/null; then
        print_success "$name is installed"

        return 0
    fi

    print_error "$name is not installed"

    return 1
}
