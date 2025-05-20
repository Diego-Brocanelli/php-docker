#!/bin/bash
set -e

# Cores para melhorar a legibilidade
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Banner do projeto
echo -e "${BLUE}"
echo "╔═════════════════════════════════════════════╗"
echo "║                                             ║"
echo "║            PHP 8.4 Docker Setup             ║"
echo "║                   V 2.0.1                   ║"
echo "║                                             ║"
echo "╚═════════════════════════════════════════════╝"
echo -e "${NC}"

# Função para exibir ajuda
show_help() {
  echo -e "${GREEN}Uso:${NC} ./setup.sh [opções]"
  echo ""
  echo "Configure e inicie um ambiente Docker para desenvolvimento PHP 8.4."
  echo ""
  echo -e "${YELLOW}Opções:${NC}"
  echo "  --help          Mostra esta mensagem de ajuda"
  echo "  --cli           Instala apenas PHP CLI (sem nginx)"
  echo "  --web           Instala PHP com Nginx (padrão)"
  echo "  --with-redis    Adiciona Redis como serviço"
  echo "  --env FILE      Usa um arquivo .env específico (padrão: .env)"
  echo ""
  echo -e "${YELLOW}Exemplos:${NC}"
  echo "  ./setup.sh --web --with-redis   # Configuração completa"
  echo "  ./setup.sh --cli                # Apenas PHP CLI + MySQL"
  echo ""
}

# Variáveis padrão
MODE="web"
USE_REDIS=false
ENV_FILE=".env"

# Processamento de argumentos
while [[ $# -gt 0 ]]; do
  case $1 in
    --help)
      show_help
      exit 0
      ;;
    --cli)
      MODE="cli"
      shift
      ;;
    --web)
      MODE="web"
      shift
      ;;
    --with-redis)
      USE_REDIS=true
      shift
      ;;
    --env)
      ENV_FILE="$2"
      shift 2
      ;;
    *)
      echo -e "${RED}Opção desconhecida: $1${NC}"
      show_help
      exit 1
      ;;
  esac
done

# solicitar nome do app (padrão: meu-app)
read -p "Digite o nome do app (padrão: meu-app): " PROJECT_NAME
if [[ -z "${PROJECT_NAME}" ]]; then
  PROJECT_NAME="meu-app"
  echo -e "${YELLOW}Nome do app não informado. Usando padrão: ${PROJECT_NAME}.${NC}"
fi

# Função para converter para CamelCase
to_camel_case() {
  local input="$1"
  # Remove caracteres não alfanuméricos, separa por espaço, coloca primeira letra maiúscula
  echo "$input" | sed -E 's/[^a-zA-Z0-9]+/ /g' | awk '{for(i=1;i<=NF;i++){ $i=toupper(substr($i,1,1)) tolower(substr($i,2)) }}1' | tr -d ' '
}

# Gera o namespace padrão: Brocanelli\PROJECT_NAME (em CamelCase)
PROJECT_NAME_CAMEL=$(to_camel_case "${PROJECT_NAME}")
DEFAULT_NAMESPACE="${PROJECT_NAME_CAMEL}\\"
AUTOLOAD_NAMESPACE="${DEFAULT_NAMESPACE}"

# Escapa as barras invertidas para JSON
AUTOLOAD_NAMESPACE_ESCAPED=$(printf '%s' "$AUTOLOAD_NAMESPACE" | sed 's/\\/\\/g')

# Atualiza o composer.json com o autoload informado
if [[ -f "composer.json" ]]; then
  jq --arg ns "$AUTOLOAD_NAMESPACE_ESCAPED" --arg dir "$AUTOLOAD_DIR" \
    '.autoload["psr-4"] = {($ns): "/src"}' composer.json > composer.tmp && mv composer.tmp composer.json
  echo "Autoload PSR-4 atualizado no composer.json: \"$AUTOLOAD_NAMESPACE\": \"/src\""
fi

# Verifica se o Docker está instalado
if ! command -v docker &> /dev/null; then
  echo -e "${RED}Docker não encontrado. Por favor, instale o Docker primeiro:${NC}"
  echo "https://docs.docker.com/get-docker/"
  exit 1
fi

# Verifica se o Docker Compose está instalado
if ! command -v docker-compose >/dev/null 2>&1 && ! docker compose version >/dev/null 2>&1; then
  echo "Erro: nem 'docker-compose' nem 'docker compose' estão instalados ou disponíveis no PATH." >&2
  exit 1
fi

# Verifica se estamos no diretório do projeto (com compose.yml)
if [[ ! -f "compose.yml" ]]; then
  echo -e "${RED}O arquivo compose.yml não foi encontrado.${NC}"
  echo "Certifique-se de estar no diretório raiz do projeto."
  exit 1
fi

# Verificar e criar arquivo .env se necessário
if [[ ! -f "${ENV_FILE}" ]]; then
  if [[ -f ".env.example" ]]; then
    echo -e "${YELLOW}Arquivo ${ENV_FILE} não encontrado. Criando a partir do exemplo...${NC}"
    cp .env.example "${ENV_FILE}"
    # Gere uma senha aleatória para o MySQL root
    sed -i "s/senha_segura/$(openssl rand -base64 12)/g" "${ENV_FILE}"
    sed -i "s/senha_app_segura/$(openssl rand -base64 12)/g" "${ENV_FILE}"
  else
    echo -e "${RED}Arquivo .env.example não encontrado. Não é possível continuar.${NC}"
    exit 1
  fi
fi

# Atualiza o valor de PROJECT_NAME no .env
if grep -q "^PROJECT_NAME=" "${ENV_FILE}"; then
  sed -i "s/^PROJECT_NAME=.*/PROJECT_NAME=${PROJECT_NAME}/" "${ENV_FILE}"
else
  echo "PROJECT_NAME=${PROJECT_NAME}" >> "${ENV_FILE}"
fi

# Atualiza o valor de MODE no .env
if grep -q "^PROJECT_MODE=" "${ENV_FILE}"; then
  sed -i "s/^PROJECT_MODE=.*/MODE=${MODE}/" "${ENV_FILE}"
else
  echo "PROJECT_MODE=${MODE}" >> "${ENV_FILE}"
fi

# Atualiza o valor de PROJECT_WITH_REDIS no .env
if [[ "${USE_REDIS}" == true ]]; then
  if grep -q "^PROJECT_WITH_REDIS=" "${ENV_FILE}"; then
    sed -i "s/^PROJECT_WITH_REDIS=.*/PROJECT_WITH_REDIS=TRUE/" "${ENV_FILE}"
  else
    echo "PROJECT_WITH_REDIS=TRUE" >> "${ENV_FILE}"
  fi
else
  if grep -q "^PROJECT_WITH_REDIS=" "${ENV_FILE}"; then
    sed -i "s/^PROJECT_WITH_REDIS=.*/PROJECT_WITH_REDIS=FALSE/" "${ENV_FILE}"
  else
    echo "PROJECT_WITH_REDIS=FALSE" >> "${ENV_FILE}"
  fi
fi

# Criar diretórios necessários
echo -e "${BLUE}Criando diretórios necessários...${NC}"
mkdir -p docker/php/conf.d
mkdir -p docker/nginx/conf.d
mkdir -p docker/nginx/ssl
mkdir -p docker/mysql/conf.d
mkdir -p docker/mysql/initdb.d
mkdir -p docker/redis

# Criar arquivo de configuração Redis se não existir
if [[ ! -f "docker/redis/redis.conf" ]]; then
  echo -e "${YELLOW}Criando arquivo de configuração do Redis...${NC}"
  echo "# Redis configuration
appendonly yes
protected-mode yes
port 6379
tcp-backlog 511
timeout 0
tcp-keepalive 300
daemonize no
supervised no
loglevel notice
databases 16
always-show-logo yes
save 900 1
save 300 10
save 60 10000
stop-writes-on-bgsave-error yes
rdbcompression yes
rdbchecksum yes
dbfilename dump.rdb
dir /data
replica-serve-stale-data yes
replica-read-only yes
repl-diskless-sync no
repl-diskless-sync-delay 5
repl-disable-tcp-nodelay no
replica-priority 100
lazyfree-lazy-eviction no
lazyfree-lazy-expire no
lazyfree-lazy-server-del no
replica-lazy-flush no
appendfsync everysec
no-appendfsync-on-rewrite no
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
aof-load-truncated yes
aof-use-rdb-preamble yes
lua-time-limit 5000
slowlog-log-slower-than 10000
slowlog-max-len 128
latency-monitor-threshold 0
notify-keyspace-events \"\"
hash-max-ziplist-entries 512
hash-max-ziplist-value 64
list-max-ziplist-size -2
list-compress-depth 0
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
hll-sparse-max-bytes 3000
stream-node-max-bytes 4096
stream-node-max-entries 100
activerehashing yes
client-output-buffer-limit normal 0 0 0
client-output-buffer-limit replica 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60
hz 10
dynamic-hz yes
aof-rewrite-incremental-fsync yes
rdb-save-incremental-fsync yes
" > docker/redis/redis.conf
fi

# Constrói os comandos Docker Compose
if command -v docker-compose >/dev/null 2>&1; then
  DOCKER_COMPOSE_CMD="docker-compose -p ${PROJECT_NAME} --profile ${MODE}"
elif docker compose version >/dev/null 2>&1; then
  DOCKER_COMPOSE_CMD="docker compose -p ${PROJECT_NAME} --profile ${MODE}"
else
  echo "Erro: nem 'docker-compose' nem 'docker compose' estão instalados ou disponíveis no PATH." >&2
  exit 1
fi

# Adiciona Redis ao comando se solicitado
if [[ "${USE_REDIS}" == true ]]; then
  DOCKER_COMPOSE_CMD="${DOCKER_COMPOSE_CMD} --profile redis"
  
  # Ajustar a dependência do app para incluir redis
  if grep -q "depends_on:" compose.yml; then
    if ! grep -q "- redis" compose.yml; then
      echo -e "${YELLOW}Adicionando dependência do Redis ao serviço app...${NC}"
      # Este sed é simplificado, pode precisar de ajustes dependendo do formato exato
      sed -i '/depends_on:/a\      - redis' compose.yml
    fi
  fi
else
  # Remove a dependência de redis do serviço app se existir
  if grep -q "depends_on:" compose.yml && grep -q "- redis" compose.yml; then
    echo -e "${YELLOW}Removendo dependência do Redis do serviço app...${NC}"
    sed -i '/- redis/d' compose.yml
  fi
fi

# Baixa os contêineres
echo -e "${BLUE}Baixando imagens dos contêineres...${NC}"
eval "${DOCKER_COMPOSE_CMD} pull"

# Constrói as imagens personalizadas
echo -e "${BLUE}Construindo contêineres...${NC}"
eval "${DOCKER_COMPOSE_CMD} build"

# Inicia os contêineres
echo -e "${GREEN}Iniciando ambiente...${NC}"
eval "${DOCKER_COMPOSE_CMD} up -d"

# Mostra o status dos contêineres
echo -e "${BLUE}Status dos contêineres:${NC}"
eval "${DOCKER_COMPOSE_CMD} ps"

# Instruções finais
echo -e "\n${GREEN}==========================${NC}"
echo -e "${GREEN}Configuração concluída!${NC}"
echo -e "${GREEN}==========================${NC}"

# Mostra informações de portas
if [[ "${MODE}" == "web" ]]; then
  NGINX_PORT=$(grep "NGINX_PORT=" "${ENV_FILE}" | cut -d= -f2 || echo "8080")
  echo -e "${YELLOW}Aplicação web disponível em:${NC} http://localhost:${NGINX_PORT}"
fi

echo -e "\nPara acessar o container PHP:"
echo -e "${BLUE}docker exec -it \$(docker-compose ps -q app) bash${NC}"

echo -e "\nPara parar o ambiente:"
echo -e "${BLUE}docker-compose down${NC}"

echo -e "\n${GREEN}Obrigado por usar nosso setup!${NC}"

# Remove o diretório .git para desvincular do repositório original
if [[ -d ".git" ]]; then
  echo -e "${YELLOW}Removendo diretório .git para desvincular do repositório original...${NC}"
  rm -rf .git
fi
