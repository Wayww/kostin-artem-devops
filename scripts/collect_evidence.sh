#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EVIDENCE_DIR="${PROJECT_ROOT}/evidence"
mkdir -p "$EVIDENCE_DIR"
cd "$PROJECT_ROOT"

./scripts/prepare_lab_environment.sh >/dev/null

{
  printf '$ pwd\n'
  pwd
  printf '\n$ find . -name application.log\n'
  find . -name 'application.log'
  printf '\n$ grep ERROR logs/application.log\n'
  grep 'ERROR' logs/application.log
  printf '\n$ grep WARNING logs/application.log\n'
  grep 'WARNING' logs/application.log
  printf '\n$ grep -c ERROR logs/application.log\n'
  grep -c 'ERROR' logs/application.log
  printf '\n$ tail -n 5 logs/application.log\n'
  tail -n 5 logs/application.log
  printf '\n$ ls -l private.txt public.txt scripts/Kostin_Artem_system.sh\n'
  ls -l private.txt public.txt scripts/Kostin_Artem_system.sh
  printf '\n$ ps -p $$ -o pid,user,%%cpu,%%mem,command\n'
  ps -p $$ -o pid,user,%cpu,%mem,command
} > "${EVIDENCE_DIR}/linux-evidence.txt"

{
  printf '$ git status --short --branch\n'
  git status --short --branch -- . ':(exclude)evidence'
  printf '\n$ git branch -avv\n'
  git branch -avv
  printf '\n$ git log --oneline --graph --decorate --all -10\n'
  git log --oneline --graph --decorate --all -10
  printf '\n$ git remote -v\n'
  git remote -v
  printf '\n$ git check-ignore -v logs/application.log backup/demo/example.txt .env\n'
  git check-ignore -v logs/application.log backup/demo/example.txt .env
} > "${EVIDENCE_DIR}/git-evidence.txt"

{
  printf '$ docker images kostin-artem-devops\n'
  docker images kostin-artem-devops
  printf '\n$ docker ps -a\n'
  docker ps -a --filter 'name=kostin-artem-container'
  printf '\n$ docker logs kostin-artem-container\n'
  docker logs kostin-artem-container
  printf '\n$ docker exec kostin-artem-container python app/main.py --check\n'
  docker exec kostin-artem-container python app/main.py --check
  printf '\n$ curl http://localhost:8080/health\n'
  curl --fail --silent --show-error http://localhost:8080/health
  printf '\n'
} > "${EVIDENCE_DIR}/docker-evidence.txt" 2>&1

printf 'Evidence collected in %s\n' "$EVIDENCE_DIR"
