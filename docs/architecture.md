# Platform architecture

## Deployment boundaries

The Compose deployment currently includes PostgreSQL, MariaDB, Redis,
Matomo, Metabase, n8n, Chatwoot (web and worker), and Horilla.
Supabase, Authentik, and Homepage are future milestones. The services
are not yet unified behind a portal or SSO provider.

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

## Next milestones

1. Add automated live smoke tests and per-service healthchecks.
2. Evaluate supported Supabase deployment and migrations.
3. Integrate Authentik, a portal, SSO and branding.
4. Traefik integration, observability, backup/restore drills and security hardening.
