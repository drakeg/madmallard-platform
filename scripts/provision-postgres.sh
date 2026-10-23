#!/bin/sh
set -eu
: "${POSTGRES_PASSWORD:?POSTGRES_PASSWORD required}"
: "${APP_DB_PASSWORD:?APP_DB_PASSWORD required}"
: "${APP_DB_NAME:?APP_DB_NAME required}"
: "${APP_DB_USER:?APP_DB_USER required}"
case "$APP_DB_NAME:$APP_DB_USER" in *[!a-zA-Z0-9_:]*|'':*|*:'') echo "Invalid database/user identifier" >&2; exit 1;; esac
docker compose exec -T -e PGPASSWORD="$POSTGRES_PASSWORD" -e APP_DB_PASSWORD="$APP_DB_PASSWORD" -e APP_DB_NAME="$APP_DB_NAME" -e APP_DB_USER="$APP_DB_USER" postgres sh -eu -c '
psql -v ON_ERROR_STOP=1 -U platform_admin -d postgres \
  -v db="$APP_DB_NAME" -v role="$APP_DB_USER" -v pw="$APP_DB_PASSWORD" <<'SQL'
SELECT format('CREATE ROLE %I LOGIN PASSWORD %L', :'role', :'pw')
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = :'role') \gexec
SELECT format('CREATE DATABASE %I OWNER %I', :'db', :'role')
WHERE NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = :'db') \gexec
SQL
'
