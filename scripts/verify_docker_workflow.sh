#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EVIDENCE_FILE="${PROJECT_ROOT}/evidence/docker-lifecycle.txt"
cd "$PROJECT_ROOT"
mkdir -p evidence
exec > >(tee "$EVIDENCE_FILE") 2>&1

printf '$ docker rm -f kostin-artem-container\n'
docker rm -f kostin-artem-container 2>/dev/null || true

printf '\n$ docker build -t kostin-artem-devops .\n'
docker build -t kostin-artem-devops .

printf '\n$ docker images kostin-artem-devops\n'
docker images kostin-artem-devops

printf '\n$ docker run -d -e STUDENT_NAME=Artem -e STUDENT_SURNAME=Kostin -e STUDENT_GROUP=IT23-14 -e STUDENT_ID=37089 --name kostin-artem-container -p 8080:8080 kostin-artem-devops\n'
docker run -d \
  -e STUDENT_NAME=Artem \
  -e STUDENT_SURNAME=Kostin \
  -e STUDENT_GROUP=IT23-14 \
  -e STUDENT_ID=37089 \
  --name kostin-artem-container \
  -p 8080:8080 \
  kostin-artem-devops

for attempt in $(seq 1 10); do
  if curl --fail --silent http://localhost:8080/health >/dev/null; then
    break
  fi
  sleep 1
done

printf '\n$ docker ps\n'
docker ps --filter 'name=kostin-artem-container'
printf '\n$ docker ps -a\n'
docker ps -a --filter 'name=kostin-artem-container'
printf '\n$ docker logs kostin-artem-container\n'
docker logs kostin-artem-container
printf '\n$ docker exec kostin-artem-container python app/main.py --check\n'
docker exec kostin-artem-container python app/main.py --check

printf '\n$ docker stop kostin-artem-container\n'
docker stop kostin-artem-container
printf '\n$ docker start kostin-artem-container\n'
docker start kostin-artem-container
printf '\n$ docker rm -f kostin-artem-container\n'
docker rm -f kostin-artem-container

printf '\n$ docker compose up --build -d\n'
docker compose up --build -d
printf '\n$ docker compose ps\n'
docker compose ps
printf '\n$ docker compose down\n'
docker compose down

printf '\nDocker workflow completed successfully.\n'
