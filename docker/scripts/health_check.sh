check_dependency()
{
    print_section "Checking dependencies..."

    check_command "docker" "Docker"
    if [ $? -ne 0 ]; then
        echo "Please install Docker: https://docs.docker.com/get-docker/"
        exit 1
    fi

    check_command "gum" "Gum"
    if [ $? -ne 0 ]; then
        echo "Please install gum.: https://github.com/charmbracelet/gum"
        exit 1
    fi

    print_success "All the dependencies are installed! 🚀"
}

#Function to check if a command is installed.
check_command() {
    local cmd=$1
    local name=${2:-$cmd}  # Friendly name (optional)
    
    if command -v "$cmd" &> /dev/null; then
        print_success "$name It is installed."

        return 0
    else
        print_error "$name It is not installed." 1

        install_tool $cmd

        check_command "$cmd" "$name"

        return 1
    fi
}

get_distro_name() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    else
        echo ""
    fi
}

install_tool() {
    local tool=$1
    local distro=$(get_distro_name)

    if [ -z "$distro" ]; then
        print_error "Distribuição Linux desconhecida"
        return 1
    fi

    print_info "Instalando $tool no $distro..."

    case $distro in 
        ubuntu|debian|pop|linuxmint|elementary)
            sudo apt update && sudo apt install -y "$tool"
            ;;
        fedora|rhel|centos)
            print "dnf install -y $tool"
            sudo dnf install -y "$tool"
            ;;
        arch|manjaro|endeavouros)
            sudo pacman -Sy --noconfirm "$tool"
            ;;
        opensuse*|sles)
            sudo zypper install -y "$tool"
            ;;
        alpine)
            sudo apk add "$tool"
            ;;
        gentoo)
            sudo emerge "$tool"
            ;;
        void)
            sudo xbps-install -y "$tool"
            ;;
        *)
            print_error "Distribuição '$distro' não suportada"
            print_info "Por favor, instale '$tool' manualmente"
            return 1
            ;;
    esac

    if [ $? -eq 0 ]; then
        print_success "$tool instalado com sucesso!"
        return 0
    else
        print_error "Falha ao instalar $tool"
        return 1
    fi
}
