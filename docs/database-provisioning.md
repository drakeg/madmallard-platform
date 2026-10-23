# Database provisioning

The shared PostgreSQL container supports separate databases and users.
Run from the repository root after starting PostgreSQL with
`docker compose up -d postgres`.

Example (use a unique random password per app):

```sh
export POSTGRES_PASSWORD='the-secret-from-your-local-env'
export APP_DB_NAME='metabase'
export APP_DB_USER='metabase'
export APP_DB_PASSWORD='unique-long-random-secret'
sh scripts/provision-postgres.sh
```

The script is intended for initial provisioning, not password rotation.
It creates roles and databases if absent. Existing passwords are unchanged.
Never paste production passwords into issue reports or commit them to Git.

Run individually for n8n, Chatwoot, Horilla, and Authentik with their own
passwords. The batch helper is only for development where a shared test
password is acceptable.

Supabase is intentionally excluded: it requires upstream-specific roles,
extensions, services and migrations. It must not be provisioned as a generic
application database.

Matomo uses the MariaDB database and account provisioned by the official
MariaDB entrypoint on first initialization.

## Future hardening
- Replace plaintext environment injection with Docker secrets.
- Add database-scoped privileges, migration checks and rotation workflows.
- Test backup and restore for each application.
