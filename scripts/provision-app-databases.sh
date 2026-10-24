#!/bin/sh
set -eu
# Usage: export POSTGRES_PASSWORD and APP_DB_PASSWORD, then run this script.
# For production, assign unique per-application passwords and run individually.
for app in metabase n8n chatwoot horilla authentik; do
  APP_DB_NAME="$app" APP_DB_USER="$app" \
    sh scripts/provision-postgres.sh
done
echo "Provisioned application databases; Supabase is excluded pending upstream compatibility validation."
