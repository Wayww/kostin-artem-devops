#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INFO_FILE="${PROJECT_ROOT}/Kostin_Artem_info.txt"

student_name="${STUDENT_NAME:-Artem}"
student_surname="${STUDENT_SURNAME:-Kostin}"
student_group="${STUDENT_GROUP:-IT23-14}"
student_id="${STUDENT_ID:-37089}"

printf '%s\n' '=============================='
printf '%s\n' 'Student Information'
printf '%s\n\n' '=============================='
printf 'Name: %s\n' "$student_name"
printf 'Surname: %s\n' "$student_surname"
printf 'Group: %s\n' "$student_group"
printf 'Student ID: %s\n' "$student_id"
printf 'Course: DevOps\n\n'

printf '%s\n' '=============================='
printf '%s\n' 'System Information'
printf '%s\n\n' '=============================='
printf 'Username: %s\n' "$(whoami)"
printf 'Hostname: %s\n' "$(hostname)"
printf 'Current Date: %s\n' "$(date '+%Y-%m-%d %H:%M:%S %Z')"
printf 'Operating System: %s\n' "$(uname -srm)"

printf '\nDisk usage:\n'
df -h "${PROJECT_ROOT}"

printf '\nMemory usage:\n'
if command -v free >/dev/null 2>&1; then
  free -h
elif command -v vm_stat >/dev/null 2>&1; then
  vm_stat
else
  printf 'Memory information command is not available.\n'
fi

if [[ -f "$INFO_FILE" ]]; then
  printf '\nStudent information file exists.\n'
else
  printf '\nStudent information file does not exist.\n' >&2
  exit 1
fi
