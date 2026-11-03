# Horilla HR

This integration uses the official multi-architecture `horilla/horilla-hr:2.2.0`
image with the existing PostgreSQL service. No separate PostgreSQL instance
is needed. The official image performs migrations and static collection on
startup; first boot can take several minutes.

## Setup

1. Copy `.env.example` to `.env`, and replace every placeholder secret.
   `HORILLA_SECRET_KEY` must be at least 50 random characters. Use a
   separate `HORILLA_DB_INIT_PASSWORD` for initial setup.
2. Start PostgreSQL: `docker compose up -d postgres`.
3. Provision Horilla's dedicated database and role:

   ```sh
   export POSTGRES_PASSWORD='your-platform-admin-password'
   export APP_DB_NAME=horilla APP_DB_USER=horilla
   export APP_DB_PASSWORD='same-value-as-HORILLA_DB_PASSWORD'
   sh scripts/provision-postgres.sh
   ```

4. Start the application: `docker compose up -d horilla`.
5. Follow startup with `docker compose logs -f horilla`. Open
   `http://localhost:8000` when ready; verify `/health/` and `/ready/`.
6. Complete first-run setup and create the administrator account.

## Security and operations

The default host binding is localhost. For external access, configure a TLS
reverse proxy and update `HORILLA_ALLOWED_HOSTS` and
`HORILLA_CSRF_TRUSTED_ORIGINS` to match the public HTTPS origin. Do not
use wildcard hosts. Back up the Horilla PostgreSQL database, media volume,
and signing secret together. The static volume can be regenerated.

Horilla's background scheduling features may require a separate scheduler
process; validate the requirements of the pinned image before enabling
scheduled payroll/leave workflows. The initial integration includes only
the web service. Test the first-run migrations and application functions
on the target Docker host before production.
