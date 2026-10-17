#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

./scripts/prepare_lab_environment.sh

printf '\n=== pwd ===\n'
pwd

printf '\n=== ls ===\n'
ls -la

printf '\n=== cd / mkdir / touch / cp / mv / rm ===\n'
cd app
pwd
cd ..
mkdir -p backup/demo
touch backup/demo/example.txt
cp public.txt backup/demo/public-copy.txt
mv backup/demo/public-copy.txt backup/demo/public-renamed.txt
rm backup/demo/example.txt

printf '\n=== cat / head / tail ===\n'
cat Kostin_Artem_info.txt
head -n 3 logs/application.log
tail -n 5 logs/application.log

printf '\n=== find / grep ===\n'
find . -name 'application.log'
grep 'ERROR' logs/application.log
grep 'WARNING' logs/application.log
grep -c 'ERROR' logs/application.log

printf '\n=== chmod / ls -l ===\n'
chmod 600 private.txt
chmod 644 public.txt
ls -l private.txt public.txt scripts/Kostin_Artem_system.sh

printf '\n=== Bash script ===\n'
./scripts/Kostin_Artem_system.sh

printf '\n=== ps ===\n'
ps

printf '\n=== ps aux ===\n'
ps aux | sed -n '1,8p'

printf '\n=== top snapshot ===\n'
if [[ "$(uname -s)" == "Darwin" ]]; then
  top -l 1 -n 5 | sed -n '1,20p'
else
  top -b -n 1 | sed -n '1,20p'
fi
