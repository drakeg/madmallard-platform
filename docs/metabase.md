# Metabase deployment

Metabase uses the existing PostgreSQL server, with a dedicated `metabase`
database and role. No separate database container or embedded H2 database is used.

## Bootstrap

1. Copy `.env.example` to `.env` and replace placeholder secrets.
2. Set `METABASE_DB_PASSWORD` to a unique random value.
3. Set `METABASE_ENCRYPTION_SECRET_KEY` to a separate strong random value.
   Keep this key safe; losing it can make encrypted Metabase settings unreadable.
4. Start PostgreSQL: `docker compose up -d postgres`.
5. Provision the dedicated database using the same password as in `.env`:

   ```sh
   export POSTGRES_PASSWORD='your-platform-admin-password'
   export APP_DB_NAME=metabase APP_DB_USER=metabase
   export APP_DB_PASSWORD='same-value-as-METABASE_DB_PASSWORD'
   sh scripts/provision-postgres.sh
   ```

6. Start Metabase: `docker compose up -d metabase`.
7. Visit `http://localhost:3001` on the Docker host and complete setup.

The default bind address is `127.0.0.1`. Change `METABASE_PORT`
for port conflicts. Use an authenticated TLS reverse proxy before enabling
external access. The database provisioning step is required before the app
can connect; `depends_on` only checks PostgreSQL readiness, not whether
the Metabase database exists.

## Operations

Back up the Metabase PostgreSQL database and encryption key together.
Pin `METABASE_IMAGE` to a tested release or immutable digest before production.
The default `latest` image is for initial integration, not a production pin.
