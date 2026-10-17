#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p "${PROJECT_ROOT}/logs" "${PROJECT_ROOT}/backup"

printf '%s\n' \
  'INFO Application started' \
  'INFO User logged in' \
  'WARNING Configuration file missing' \
  'INFO Database connected' \
  'ERROR Database connection failed' \
  'INFO Application restarted' \
  'WARNING Memory usage is high' \
  'INFO Request received' \
  'ERROR Request failed' \
  'INFO Application stopped' \
  > "${PROJECT_ROOT}/logs/application.log"

chmod 600 "${PROJECT_ROOT}/private.txt"
chmod 644 "${PROJECT_ROOT}/public.txt"
chmod 755 \
  "${PROJECT_ROOT}/scripts/Kostin_Artem_system.sh" \
  "${PROJECT_ROOT}/scripts/demo_linux.sh" \
  "${PROJECT_ROOT}/scripts/prepare_lab_environment.sh"

printf 'Laboratory environment prepared in %s\n' "$PROJECT_ROOT"
