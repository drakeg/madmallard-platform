# Chatwoot customer support

Chatwoot runs as a Rails web service and a Sidekiq background worker,
sharing the platform PostgreSQL and Redis servers. Both services share the
`chatwoot_storage` volume for local Active Storage files.

## First-time setup

1. Copy `.env.example` to `.env` and replace all placeholder secrets.
   Generate `CHATWOOT_SECRET_KEY_BASE` with `openssl rand -hex 64`.
2. Start the databases: `docker compose up -d postgres redis`.
3. Provision an isolated PostgreSQL database and role using the same
   password as `CHATWOOT_DB_PASSWORD` in `.env`:

   ```sh
   export POSTGRES_PASSWORD='platform-admin-password'
   export APP_DB_NAME=chatwoot APP_DB_USER=chatwoot
   export APP_DB_PASSWORD='same-value-as-CHATWOOT_DB_PASSWORD'
   sh scripts/provision-postgres.sh
   ```

4. Run the official Chatwoot database setup **before** starting the app:

   ```sh
   docker compose run --rm --no-deps chatwoot bundle exec rails db:chatwoot_prepare
   ```

5. Start both processes: `docker compose up -d chatwoot chatwoot-worker`.
6. Open `http://localhost:3002` on the Docker host.

## Deployment notes

The HTTP port is bound to loopback by default. For a public deployment,
place Chatwoot behind a TLS reverse proxy and configure
`CHATWOOT_FRONTEND_URL` to its actual HTTPS URL. Set up SMTP and inbound
channels separately before production use.

`CHATWOOT_ENABLE_ACCOUNT_SIGNUP=false` disables open account registration;
plan the initial administrator creation accordingly. You may temporarily
enable signup for controlled initial setup, then disable it again.

Chatwoot's PostgreSQL database, `chatwoot_storage` volume, and secrets
must be backed up together. The default image tag is for initial
integration; pin a tested release/digest before production.
