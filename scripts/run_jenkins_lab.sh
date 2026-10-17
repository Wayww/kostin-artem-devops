#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

JENKINS_URL="${JENKINS_URL:-http://localhost:8081}"
JOB_NAME="Kostin_Artem_DevOps"
EVIDENCE_DIR="${PROJECT_ROOT}/evidence"

mkdir -p "$EVIDENCE_DIR"

# Port 8080 is reserved for the application started by the Jenkins Pipeline.
docker compose down >/dev/null 2>&1 || true
docker compose -f docker-compose.jenkins.yml up --build -d

printf 'Waiting for Jenkins at %s ...\n' "$JENKINS_URL"
for attempt in $(seq 1 90); do
  if curl --fail --silent "${JENKINS_URL}/api/json" >/dev/null; then
    break
  fi
  if [[ "$attempt" -eq 90 ]]; then
    printf 'Jenkins did not become ready.\n' >&2
    exit 1
  fi
  sleep 2
done

if curl --fail --silent "${JENKINS_URL}/job/${JOB_NAME}/api/json" >/dev/null; then
  curl --fail --silent --show-error \
    -X POST \
    -H 'Content-Type: application/xml' \
    --data-binary @jenkins/job-config.xml \
    "${JENKINS_URL}/job/${JOB_NAME}/config.xml" >/dev/null
else
  curl --fail --silent --show-error \
    -X POST \
    -H 'Content-Type: application/xml' \
    --data-binary @jenkins/job-config.xml \
    "${JENKINS_URL}/createItem?name=${JOB_NAME}" >/dev/null
fi

curl --fail --silent --show-error \
  -X POST "${JENKINS_URL}/job/${JOB_NAME}/build?delay=0sec" >/dev/null

printf 'Waiting for Jenkins build ...\n'
build_number=""
for attempt in $(seq 1 120); do
  build_json="$(curl --fail --silent "${JENKINS_URL}/job/${JOB_NAME}/lastBuild/api/json" 2>/dev/null || true)"
  if [[ -n "$build_json" ]]; then
    build_number="$(printf '%s' "$build_json" | jq -r '.number')"
    building="$(printf '%s' "$build_json" | jq -r '.building')"
    result="$(printf '%s' "$build_json" | jq -r '.result')"
    if [[ "$building" == "false" && "$result" != "null" ]]; then
      break
    fi
  fi
  if [[ "$attempt" -eq 120 ]]; then
    printf 'Jenkins build did not finish.\n' >&2
    exit 1
  fi
  sleep 2
done

curl --fail --silent --show-error \
  "${JENKINS_URL}/job/${JOB_NAME}/${build_number}/consoleText" \
  > "${EVIDENCE_DIR}/jenkins-console.txt"
curl --fail --silent --show-error \
  "${JENKINS_URL}/job/${JOB_NAME}/${build_number}/api/json" \
  > "${EVIDENCE_DIR}/jenkins-build.json"

result="$(jq -r '.result' "${EVIDENCE_DIR}/jenkins-build.json")"
printf 'Jenkins Job: %s\n' "$JOB_NAME"
printf 'Build Number: %s\n' "$build_number"
printf 'Result: %s\n' "$result"
printf 'Console: %s/job/%s/%s/console\n' "$JENKINS_URL" "$JOB_NAME" "$build_number"

if [[ "$result" != "SUCCESS" ]]; then
  tail -n 80 "${EVIDENCE_DIR}/jenkins-console.txt" >&2
  exit 1
fi
