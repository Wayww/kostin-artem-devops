#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
JENKINS_CONTAINER="${JENKINS_CONTAINER:-kostin-artem-jenkins}"
WORKSPACE="/var/jenkins_home/workspace/Kostin_Artem_DevOps"

mkdir -p "${PROJECT_ROOT}/evidence"

docker exec \
  -e STUDENT_NAME=Artem \
  -e STUDENT_SURNAME=Kostin \
  -e STUDENT_GROUP=IT23-14 \
  -e STUDENT_ID=37089 \
  "$JENKINS_CONTAINER" \
  bash -lc "cd '${WORKSPACE}' && ./scripts/demo_linux.sh" \
  > "${PROJECT_ROOT}/evidence/linux-container-evidence.txt"

printf 'Linux container evidence saved to evidence/linux-container-evidence.txt\n'
