#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# run.sh — Docker Service Helper
# ─────────────────────────────────────────────────────────────────────────────
# Usage:
#   ./run.sh <service> <env> [command] [options]
#
# Arguments:
#   service   Service folder name (e.g. postgres-pgadmin, redis, rabbitmq)
#             Use "all" to target every service that has an .env.<env> file
#   env       Environment: dev | prod
#   command   Docker Compose command (default: up -d)
#
# Examples:
#   ./run.sh postgres-pgadmin dev              # start postgres dev
#   ./run.sh postgres-pgadmin prod             # start postgres prod
#   ./run.sh redis dev down                    # stop redis dev
#   ./run.sh monitoring-stack dev logs -f      # follow logs
#   ./run.sh all dev up -d                     # start all services (dev)
#   ./run.sh all prod down                     # stop all services (prod)
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Colors ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# ── Help ─────────────────────────────────────────────────────────────────────
usage() {
  grep '^# ' "$0" | sed 's/^# \?//'
  exit 0
}

[[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && usage

# ── Validate arguments ───────────────────────────────────────────────────────
SERVICE="${1:-}"
ENV="${2:-}"
COMPOSE_CMD="${3:-up}"
COMPOSE_ARGS="${@:4}"

if [[ -z "$SERVICE" || -z "$ENV" ]]; then
  echo -e "${RED}Error:${NC} Missing arguments.\n"
  usage
fi

if [[ "$ENV" != "dev" && "$ENV" != "prod" ]]; then
  echo -e "${RED}Error:${NC} env must be 'dev' or 'prod', got '${ENV}'"
  exit 1
fi

# ── Find docker-compose file ─────────────────────────────────────────────────
find_compose_file() {
  local dir="$1"
  if [[ -f "$dir/docker-compose.yml" ]]; then
    echo "$dir/docker-compose.yml"
  elif [[ -f "$dir/docker-compose.yaml" ]]; then
    echo "$dir/docker-compose.yaml"
  else
    echo ""
  fi
}

# ── Run single service ───────────────────────────────────────────────────────
run_service() {
  local svc="$1"
  local svc_dir="$SCRIPT_DIR/$svc"

  if [[ ! -d "$svc_dir" ]]; then
    echo -e "${RED}Error:${NC} Service directory '$svc' not found."
    exit 1
  fi

  local env_file="$svc_dir/.env.$ENV"
  if [[ ! -f "$env_file" ]]; then
    echo -e "${YELLOW}Warning:${NC} '$svc/.env.$ENV' not found."
    echo -e "  → Copy '$svc/.env.example' to '$svc/.env.$ENV' and fill in the values."
    exit 1
  fi

  local compose_file
  compose_file="$(find_compose_file "$svc_dir")"
  if [[ -z "$compose_file" ]]; then
    echo -e "${RED}Error:${NC} No docker-compose file found in '$svc/'."
    exit 1
  fi

  echo -e "${CYAN}▶ [$svc]${NC} ENV=${ENV} — docker compose ${COMPOSE_CMD} ${COMPOSE_ARGS}"
  docker compose \
    -f "$compose_file" \
    --env-file "$env_file" \
    $COMPOSE_CMD $COMPOSE_ARGS
}

# ── Run all services ─────────────────────────────────────────────────────────
run_all() {
  local services=()
  for dir in "$SCRIPT_DIR"/*/; do
    local svc
    svc="$(basename "$dir")"
    [[ -f "$dir/.env.$ENV" ]] && services+=("$svc")
  done

  if [[ ${#services[@]} -eq 0 ]]; then
    echo -e "${YELLOW}Warning:${NC} No service has an '.env.$ENV' file yet."
    echo "  → Copy each service's .env.example to .env.$ENV and fill in the values."
    exit 1
  fi

  echo -e "${GREEN}Running ${#services[@]} service(s) [${ENV}]: ${services[*]}${NC}\n"
  for svc in "${services[@]}"; do
    run_service "$svc" || true
    echo
  done
}

# ── Main ─────────────────────────────────────────────────────────────────────
if [[ "$SERVICE" == "all" ]]; then
  run_all
else
  run_service "$SERVICE"
fi
