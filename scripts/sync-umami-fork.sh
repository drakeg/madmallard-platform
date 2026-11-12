#!/usr/bin/env bash
set -euo pipefail
# Refresh the test-suite Umami from the user's fork, without touching its database.
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="${UMAMI_SOURCE_DIR:-${TMPDIR:-/tmp}/madmallard-umami-source}"
FORK_URL="${UMAMI_FORK_URL:-https://github.com/drakeg/umami.git}"
BRANCH="${UMAMI_FORK_BRANCH:-master}"
cd "$ROOT"
if [[ ! -f .env ]]; then echo "Missing .env" >&2; exit 1; fi
if [[ ! -d "$SOURCE_DIR/.git" ]]; then
  git clone --depth 1 --branch "$BRANCH" "$FORK_URL" "$SOURCE_DIR"
else
  git -C "$SOURCE_DIR" fetch --depth 1 origin "$BRANCH"
  git -C "$SOURCE_DIR" checkout --detach FETCH_HEAD
fi
SHA="$(git -C "$SOURCE_DIR" rev-parse --short=12 HEAD)"
TAG="drakeg-umami:$SHA"
echo "Building Umami fork commit $SHA"
docker build -t "$TAG" "$SOURCE_DIR"
# Keep the previous image in place until the new build succeeds.
cp .env ".env.umami-backup"
python3 - "$TAG" <<'PY'
from pathlib import Path
import sys
p = Path('.env')
lines = p.read_text().splitlines()
lines = [x for x in lines if not x.startswith('UMAMI_IMAGE=')]
lines.append('UMAMI_IMAGE=' + sys.argv[1])
p.write_text('\n'.join(lines) + '\n')
PY
if ! docker compose config --quiet || ! docker compose up -d --no-deps umami; then
  cp ".env.umami-backup" .env
  docker compose up -d --no-deps umami
  exit 1
fi
for ((attempt=0; attempt<36; attempt++)); do
  if [[ "$(docker inspect madmallard-umami-1 --format '{{if .State.Health}}{{.State.Health.Status}}{{end}}' 2>/dev/null)" == "healthy" ]] && curl -fsS --max-time 4 http://127.0.0.1:"${UMAMI_PORT:-3005}"/ >/dev/null; then
    rm -f .env.umami-backup
    echo "Umami $SHA healthy and deployed"
    exit 0
  fi
  sleep 5
done
echo "New Umami image failed health check; restoring previous image" >&2
cp ".env.umami-backup" .env
docker compose up -d --no-deps umami
exit 1
