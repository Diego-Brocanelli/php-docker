#!/usr/bin/env bash
# shellcheck disable=SC2034 # Cores consumidas por text.sh

# Desativa cores quando a saída não é um terminal ou NO_COLOR está definido
if [[ -t 2 && -z "${NO_COLOR:-}" ]]; then
    readonly RED=$'\033[0;31m'
    readonly GREEN=$'\033[0;32m'
    readonly YELLOW=$'\033[1;33m'
    readonly BLUE=$'\033[0;34m'
    readonly MAGENTA=$'\033[0;35m'
    readonly CYAN=$'\033[0;36m'
    readonly BOLD=$'\033[1m'
    readonly NC=$'\033[0m' # No color
else
    readonly RED='' GREEN='' YELLOW='' BLUE='' MAGENTA='' CYAN='' BOLD='' NC=''
fi
