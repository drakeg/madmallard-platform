# n8n workflow automation

n8n uses the shared PostgreSQL server with its own database and role.
The `n8n_data` volume persists local application state. Keep it and the
PostgreSQL database in coordinated backups.

## Setup

1. Copy `.env.example` to `.env` and replace placeholder passwords.
2. Generate a unique, long `N8N_DB_PASSWORD` and a separate stable
   `N8N_ENCRYPTION_KEY`. Never change the encryption key without a
   supported migration, or saved credentials may become unreadable.
3. Start PostgreSQL: `docker compose up -d postgres`.
4. Provision the database using the same password as `N8N_DB_PASSWORD`:

   ```sh
   export POSTGRES_PASSWORD='your-platform-admin-password'
   export APP_DB_NAME=n8n APP_DB_USER=n8n
   export APP_DB_PASSWORD='same-value-as-N8N_DB_PASSWORD'
   sh scripts/provision-postgres.sh
   ```

5. Start n8n: `docker compose up -d n8n`.
6. Open `http://localhost:5678` on the host and complete owner setup.

## Networking

`N8N_PORT` changes the host port; n8n still listens on port 5678
inside the container. The default host binding is loopback only.
For external webhook delivery, configure an HTTPS reverse proxy,
set `N8N_HOST`, `N8N_PROTOCOL=https`, and `N8N_WEBHOOK_URL` to the
public HTTPS base URL. Proxy trust settings must match your deployment.
Never expose the n8n editor publicly without authentication and TLS.

## Operations

This initial integration uses the regular execution mode, not queue mode;
Redis is not required by this n8n service. Test database migrations and
pin `N8N_IMAGE` to a verified release/digest before production.
