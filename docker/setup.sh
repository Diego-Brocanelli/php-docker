#!/bin/bash
# Shebang: define que o script deve ser executado com bash

# =================== DEFINIÇÃO DE CORES ANSI ===================
# Códigos de escape ANSI para colorir texto no terminal
RED='\033[0;31m'      # Define código para cor vermelha
GREEN='\033[0;32m'    # Define código para cor verde  
YELLOW='\033[1;33m'   # Define código para cor amarela (bold)
BLUE='\033[0;34m'     # Define código para cor azul
NC='\033[0m'          # No Color - código para resetar cores

# =================== VARIÁVEIS GLOBAIS DO SCRIPT ===================
DOCKER_DIR=$(pwd)                           # Obtém diretório atual onde o script está sendo executado
PROJECT_DIR="$(dirname "$DOCKER_DIR")"      # Obtém diretório pai (um nível acima do atual)
TEMPLATES_DIR="$DOCKER_DIR/templates"       # Define caminho para diretório de templates
GENERATED_DIR="$PROJECT_DIR"                # Define onde arquivos serão gerados (raiz do projeto)
COMPOSE_FILES=()                            # Inicializa array vazio para armazenar caminhos dos arquivos compose

# =================== FUNÇÕES UTILITÁRIAS ===================

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

define_projetc_name() {
    # Caminho do arquivo .env.template
    ENV_FILE=${GENERATED_DIR}"/.env.docker"

    # Loop até o usuário digitar um nome válido
    while true; do
        read -p "Digite o nome do projeto: " PROJECT_NAME

        print_message $GREEN "✓ Docker Compose plugin detectado"

        if [[ -n "$PROJECT_NAME" ]]; then
            print_message $GREEN "✓ Projeto ${PROJECT_NAME}"
            break
        else
            echo "O nome do projeto não pode ser vazio. Tente novamente."
        fi
    done

    # Substitui o valor de PROJECT_NAME no arquivo
    sed -i "s/^PROJECT_NAME=.*/PROJECT_NAME=${PROJECT_NAME}/" "$ENV_FILE"

    print_message $GREEN "✓ Variável PROJECT_NAME atualizada para ${PROJECT_NAME} em ${ENV_FILE}"
}

# =================== VERIFICAÇÃO DE DEPENDÊNCIAS ===================

# Função para verificar se Docker e Docker Compose estão disponíveis
check_docker_compose() {
    # Verifica se comando 'docker' existe no PATH
    if ! command -v docker &> /dev/null; then
        print_message $RED "Erro: Docker não está instalado ou não está no PATH"
        exit 1        # Termina script com código de erro
    fi
    
    # Verifica se plugin 'docker compose' funciona
    if ! docker compose version &> /dev/null; then
        print_message $RED "Erro: Docker Compose plugin não está disponível"
        print_message $YELLOW "Certifique-se de que o Docker Compose plugin está instalado"
        exit 1        # Termina script com código de erro
    fi
    
    print_message $GREEN "✓ Docker Compose plugin detectado"  # Sucesso em verde
}

# =================== FUNÇÕES DE CONFIGURAÇÃO ===================

# Função para inicializar configuração do projeto
init_project() {
    # Exibe título principal em azul
    print_message $BLUE "=== Configuração do Projeto PHP Docker ==="
    echo              # Linha em branco

    # Chama verificação de dependências
    check_docker_compose
    
    # Adiciona arquivo base obrigatório ao array de arquivos compose
    COMPOSE_FILES+=("$TEMPLATES_DIR/base/compose.base.yml")
    
    # Copia template de variáveis de ambiente para arquivo .env.docker na raiz
    cp "$TEMPLATES_DIR/base/.env.template" "$GENERATED_DIR/.env.docker"
}

# Versão simplificada para configurar tipo de projeto (sem command substitution)
configure_project_type() {
    print_message $YELLOW "Tipo de Projeto:"  # Título da seção em amarelo
    echo                                      # Linha em branco
    echo "Selecione o tipo de projeto:"       # Instrução
    echo "1. Web (PHP + Nginx)"               # Opção 1
    echo "2. CLI (PHP)"                       # Opção 2
    echo                                      # Linha em branco
    
    while true; do    # Loop até escolha válida
        echo -n "Escolha uma opção (1-2): "   # Prompt sem quebra de linha
        read choice   # Lê entrada do usuário
        
        case $choice in     # Avalia escolha
            1)              # Se escolheu 1
                project_type="Web (PHP + Nginx)"                           # Define tipo
                COMPOSE_FILES+=("$TEMPLATES_DIR/services/nginx.yml")       # Adiciona Nginx
                echo "PROJECT_TYPE=web" >> "$GENERATED_DIR/.env.docker"    # Adiciona variável ao .env
                break       # Sai do loop
                ;;
            2)              # Se escolheu 2  
                project_type="CLI (PHP)"                                   # Define tipo
                echo "PROJECT_TYPE=cli" >> "$GENERATED_DIR/.env.docker"    # Adiciona variável ao .env
                break       # Sai do loop
                ;;
            *)              # Qualquer outra entrada
                print_message $RED "Opção inválida. Tente novamente."     # Erro em vermelho
                ;;
        esac
    done
    
    # Sempre adiciona PHP independente da escolha
    COMPOSE_FILES+=("$TEMPLATES_DIR/services/php84.yml")
    print_message $GREEN "✓ Tipo de projeto: $project_type"  # Confirmação em verde
}

# Função para configurar banco de dados
configure_database() {
    print_message $YELLOW "Banco de Dados:"

    while true; do    # Loop até escolha válida
        echo
        echo "Selecione o banco de dados desejado:"
        echo "1. MySQL"
        echo "2. PostgresSQL"
        echo "3. MongoDB"
        echo "4. Nenhum"
        echo

        echo -n "Escolha uma opção (1-4): "   # Prompt sem quebra de linha

        read choice   # Lê entrada do usuário
        
        case $choice in     # Avalia escolha
            1)        # Se MySQL
                COMPOSE_FILES+=("$TEMPLATES_DIR/services/mysql.yml")       # Adiciona arquivo MySQL
                echo "DATABASE_TYPE=mysql" >> "$GENERATED_DIR/.env.docker" # Adiciona variável

                print_message $GREEN "✓ MySQL selecionado"    # Confirmação

                break       # Sai do loop
                ;;
            2)   # Se PostgreSQL
                COMPOSE_FILES+=("$TEMPLATES_DIR/services/postgreSql.yml")       # Adiciona arquivo Postgres
                echo "DATABASE_TYPE=postgres" >> "$GENERATED_DIR/.env.docker" # Adiciona variável

                print_message $GREEN "✓ PostgreSQL selecionado"    # Confirmação

                break       # Sai do loop
                ;;
            3)      # Se MongoDB
                COMPOSE_FILES+=("$TEMPLATES_DIR/services/mongoDb.yml")        # Adiciona arquivo MongoDB
                echo "DATABASE_TYPE=mongodb" >> "$GENERATED_DIR/.env.docker"  # Adiciona variável

                print_message $GREEN "✓ MongoDB selecionado"    # Confirmação

                break       # Sai do loop
                ;;
            4)       # Se nenhum
                echo "DATABASE_TYPE=none" >> "$GENERATED_DIR/.env.docker"     # Adiciona variável

                print_message $GREEN "✓ Nenhum banco de dados selecionado"    # Confirmação

                break       # Sai do loop
                ;;
            *)              # Qualquer outra entrada
                print_message $RED "Opção inválida. Tente novamente."     # Erro em vermelho
                ;;
        esac
    done
}

# Função para configurar serviços adicionais
configure_additional_services() {
    print_message $YELLOW "Serviços Adicionais:"  # Título da seção

    # Pergunta sobre Redis
    if ask_yes_no "Incluir Redis?"; then
        COMPOSE_FILES+=("$TEMPLATES_DIR/services/redis.yml")        # Adiciona arquivo Redis
        echo "REDIS_ENABLED=true" >> "$GENERATED_DIR/.env.docker"   # Marca como habilitado
        print_message $GREEN "✓ Redis incluído"                    # Confirmação
    else
        echo "REDIS_ENABLED=false" >> "$GENERATED_DIR/.env.docker"  # Marca como desabilitado
    fi

    # Pergunta sobre RabbitMQ
    if ask_yes_no "Incluir RabbitMQ?"; then
        COMPOSE_FILES+=("$TEMPLATES_DIR/services/rabbitMQ.yml")        # Adiciona arquivo RabbitMQ
        echo "RABBITMQ_ENABLED=true" >> "$GENERATED_DIR/.env.docker"   # Marca como habilitado
        print_message $GREEN "✓ RabbitMQ incluído"                    # Confirmação
    else
        echo "RABBITMQ_ENABLED=false" >> "$GENERATED_DIR/.env.docker"  # Marca como desabilitado
    fi
}

# =================== GERAÇÃO DE ARQUIVOS FINAIS ===================

# Função para gerar arquivos docker-compose finais
generate_compose_file() {
    print_message $BLUE "Gerando arquivos de configuração..."  # Título da etapa
    
    # Inicializa variável para parâmetros do comando compose
    local compose_files_param=""
    
    # Loop através de todos os arquivos compose coletados
    for file in "${COMPOSE_FILES[@]}"; do
        if [[ -f "$file" ]]; then  # Se arquivo existe
            # Calcula caminho relativo do arquivo em relação ao diretório gerado
            local relative_path=$(realpath --relative-to="$GENERATED_DIR" "$file")
            # Adiciona parâmetro -f com o caminho relativo
            compose_files_param="$compose_files_param -f $relative_path"
        else
            # Se arquivo não existe, exibe aviso
            print_message $RED "Aviso: Arquivo $file não encontrado"
        fi
    done
    
    # Gera script executável docker-compose.sh na raiz do projeto
    cat > "$GENERATED_DIR/docker-compose.sh" << EOF
#!/bin/bash
# Script gerado automaticamente pelo docker/setup.sh
# Arquivos utilizados: ${COMPOSE_FILES[*]}

# Função para executar docker compose com configurações corretas
run_docker_compose() {
    # Lista de arquivos compose relativos ao diretório atual
    local compose_files=($(echo "${COMPOSE_FILES[*]}" | sed "s|$DOCKER_DIR/||g"))
    local files_param=""
    
    # Construir parâmetros -f para cada arquivo
    for file in "\${compose_files[@]}"; do
        if [[ -f "docker/\$file" ]]; then
            files_param="\$files_param -f docker/\$file"
        fi
    done
    
    # Executar comando docker compose
    docker compose --env-file .env.docker \$files_param "\$@"
}

# Chamar função com todos os argumentos passados
run_docker_compose "\$@"
EOF

    # Torna o script executável
    chmod +x "$GENERATED_DIR/docker-compose.sh"

    # Navega para diretório de destino para gerar arquivo consolidado
    cd "$GENERATED_DIR"
    
    # Inicializa variável para parâmetros do config
    local files_for_config=""
    # Loop similar ao anterior para montar comando config
    for file in "${COMPOSE_FILES[@]}"; do
        if [[ -f "$file" ]]; then  # Se arquivo existe
            # Calcula caminho relativo
            local relative_path=$(realpath --relative-to="$GENERATED_DIR" "$file")
            # Adiciona ao parâmetro
            files_for_config="$files_for_config -f $relative_path"
        fi
    done

    # Tenta gerar arquivo compose.yml consolidado
    if docker compose --env-file .env.docker $files_for_config config > $GENERATED_DIR/compose.yml 2>/dev/null; then
        # o arquivo é consolidato com o caminho completo, removo para ficar relativo.
        PARENT_DIR="${PWD}" # Guarda o diretório pai
        sed -i.bak "s|$PARENT_DIR|.|g" $GENERATED_DIR/compose.yml

        print_message $GREEN "********************************"  # Sucesso
        print_message $GREEN "✓ compose.yml consolidado gerado"  # Sucesso
    else
        # Se falhou, cria arquivo com comentários explicativos
        echo "# Configuração gerada pelo docker/setup.sh" > compose.yml
        echo "# Erro ao consolidar arquivos - use docker-compose.sh" >> compose.yml
        print_message $YELLOW "*****************************************************************"
        print_message $YELLOW "⚠ Arquivo consolidado não pôde ser gerado - use docker-compose.sh"
    fi
    
    # Retorna ao diretório original
    cd "$DOCKER_DIR"
    
    print_message $GREEN "✓ Arquivos gerados em: $GENERATED_DIR/"  # Confirmação final
}

# =================== RESUMO E INSTRUÇÕES ===================

# Função para exibir resumo final e próximos passos
show_summary() {
    echo                                      # Linha em branco
    print_message $BLUE "=== Resumo da Configuração ==="  # Título do resumo
    echo                                      # Linha em branco
    print_message $GREEN "Arquivos gerados:" # Subtítulo
    # Lista os arquivos gerados com seus caminhos completos
    echo "  • $GENERATED_DIR/.env.docker"
    echo "  • $GENERATED_DIR/docker-compose.sh"
    echo "  • $GENERATED_DIR/compose.yml"
    echo                                      # Linha em branco
    print_message $YELLOW "Próximos passos:" # Subtítulo
    # Instruções numeradas para o usuário
    echo "  1. cd \"$(basename "$GENERATED_DIR")\""  # Navegar para diretório (só nome, não path completo)
    echo "  2. ./docker-compose.sh up -d"            # Subir containers em background
    echo "  3. ./docker-compose.sh logs -f (para ver os logs)"  # Ver logs em tempo real
    echo                                      # Linha em branco
    print_message $BLUE "Alternativa usando Docker Compose diretamente:"  # Método alternativo
    echo "  • docker compose --env-file .env.docker up -d"     # Comando direto
    echo                                      # Linha em branco
    print_message $GREEN "Comandos úteis:"   # Lista de comandos úteis
    echo "  • Parar: ./docker-compose.sh down"                        # Parar containers
    echo "  • Rebuild: ./docker-compose.sh up --build -d"             # Rebuild e subir
    echo "  • Entrar no container PHP: ./docker-compose.sh exec php bash"  # Acessar container
    echo "  • Ver status: ./docker-compose.sh ps"                     # Ver status dos containers
    echo                                      # Linha em branco final
}

# =================== FUNÇÃO PRINCIPAL ===================

# Função principal que orquestra todo o processo
main() {
    # Verifica se está executando no diretório correto
    if [[ ! -d "$TEMPLATES_DIR" ]]; then
        # Se diretório templates não existe, exibe erro e sai
        print_message $RED "Erro: Diretório templates/ não encontrado!"
        print_message $YELLOW "Execute este script no diretório docker/"
        exit 1        # Termina com código de erro
    fi
    
    # Executa sequência de configuração na ordem correta
    init_project                      # 1. Inicialização
    define_projetc_name               # 2. Define o nome do projeto no .env.docker
    configure_project_type            # 3. Tipo de projeto
    configure_database                # 4. Banco de dados
    configure_additional_services     # 5. Serviços extras
    generate_compose_file             # 6. Gerar arquivos finais
    show_summary                      # 7. Mostrar resumo
}

# =================== EXECUÇÃO DO SCRIPT ===================

# Chama função principal passando todos os argumentos da linha de comando
main "$@"
