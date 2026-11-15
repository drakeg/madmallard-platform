#!/usr/bin/env bash
# Read-only operational audit for the configured Compose project.
set -euo pipefail
cd "$(dirname "$0")/.."
command -v docker >/dev/null || { echo 'Docker CLI missing' >&2; exit 2; }
docker compose config --quiet
project="$(docker compose config --format json | python3 -c 'import json,sys; print(json.load(sys.stdin)["name"])')"
mapfile_compat() { while IFS= read -r line; do SERVICES+=("$line"); done; }
SERVICES=()
mapfile_compat < <(docker compose config --services)
fail=0
printf 'Compose project: %s\n' "$project"
for service in "${SERVICES[@]}"; do
  cid="$(docker compose ps -q "$service")"
  if [[ -z "$cid" ]]; then
    printf 'FAIL %-18s missing container\n' "$service"
    fail=1
    continue
  fi
  state="$(docker inspect -f '{{.State.Status}}' "$cid")"
  health="$(docker inspect -f '{{if .State.Health}}{{.State.Health.Status}}{{else}}not-configured{{end}}' "$cid")"
  if [[ "$state" != running || "$health" == unhealthy ]]; then
    printf 'FAIL %-18s state=%s health=%s\n' "$service" "$state" "$health"
    fail=1
  else
    printf 'OK   %-18s state=%s health=%s\n' "$service" "$state" "$health"
  fi
done
exit "$fail"
