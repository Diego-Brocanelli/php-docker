#!/bin/bash

# =================== DEFINIÇÃO DE CORES ANSI ===================
# Códigos de escape ANSI para colorir texto no terminal
RED='\033[0;31m'      # Define código para cor vermelha
GREEN='\033[0;32m'    # Define código para cor verde  
YELLOW='\033[1;33m'   # Define código para cor amarela (bold)
BLUE='\033[0;34m'     # Define código para cor azul
NC='\033[0m'          # No Color - código para resetar cores

# =================== VARIÁVEIS GLOBAIS DO SCRIPT ===================
ROOT_DIR=$(dirname "$(dirname "$PWD")")
PROJECT_DIR=$ROOT_DIR
TEMPLATES_DIR="$ROOT_DIR/docker/templates"
CONFIG_BASE_NGINX=${ROOT_DIR}"/docker/templates/services/nginx/config/default.base.conf"
BASE_ENV_FILE=${ROOT_DIR}"/docker/templates/base/.env.docker"
COMPOSE_FILES=()                            # Inicializa array vazio para armazenar caminhos dos arquivos compose
