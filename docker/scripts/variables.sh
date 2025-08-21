#!/bin/bash

# =================== DEFINIÇÃO DE CORES ANSI ===================
# Códigos de escape ANSI para colorir texto no terminal
RED='\033[0;31m'      # Define código para cor vermelha
GREEN='\033[0;32m'    # Define código para cor verde  
YELLOW='\033[1;33m'   # Define código para cor amarela (bold)
BLUE='\033[0;34m'     # Define código para cor azul
NC='\033[0m'          # No Color - código para resetar cores

# =================== VARIÁVEIS GLOBAIS DO SCRIPT ===================
# Diretório onde este script está localizado
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR=$(pwd)                           # Obtém diretório atual onde o script está sendo executado
SCRIPTS_DIR="$PROJECT_DIR/docker/scripts"
DOCKER_DIR=$(pwd)                           # Obtém diretório atual onde o script está sendo executado
PROJECT_DIR="$(dirname "$DOCKER_DIR")"      # Obtém diretório pai (um nível acima do atual)
TEMPLATES_DIR="$(dirname "$DOCKER_DIR")/templates"       # Define caminho para diretório de templates
GENERATED_DIR="$PROJECT_DIR"                # Define onde arquivos serão gerados (raiz do projeto)
ROOT_DIR="."                                # Rraiz do projeto
CONFIG_DIR=${PROJECT_DIR}"/templates/configs"
COMPOSE_FILES=()                            # Inicializa array vazio para armazenar caminhos dos arquivos compose
CONFIG_BASE_NGINX=${PROJECT_DIR}"/templates/configs/nginx/default.base.conf"
BASE_ENV_FILE=${PROJECT_DIR}"/templates/configs/.env.docker"
