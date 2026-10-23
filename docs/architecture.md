# Platform architecture

## Deployment boundaries

This first milestone supplies **infrastructure only**: PostgreSQL, MariaDB,
and Redis. It does not yet deploy the eight planned applications.

The final release will expose a single primary Compose entrypoint while
allowing integration with an existing Traefik and monitoring installation.

## Shared resources

- PostgreSQL: dedicated databases and least-privilege users for compatible apps.
- MariaDB: Matomo, which requires a MySQL-compatible engine.
- Redis: shared server where supported, with app-level isolation and ACLs
  planned before applications are connected.
- Supabase: preserve upstream-supported roles, extensions, migrations and
  services; evaluate compatibility before using the common PostgreSQL instance.
- Existing Traefik, Grafana, Prometheus and backup systems are not recreated.

## Security

Database and Redis services have no published host ports and live on an
internal Docker network. Credentials must never be committed. Replace example
secrets before starting. A later milestone will move production credentials to
Docker secrets and define rotation procedures.

## Roadmap

1. Infrastructure and validation (this PR).
2. Database provisioning and secrets.
3. Vendor-supported Supabase services and migration checks.
4. Matomo, Metabase, n8n, Chatwoot, Horilla.
5. Authentik, portal, SSO integration and branding.
6. Traefik integration, observability, backups, restore drills and security hardening.
