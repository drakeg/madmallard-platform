# Mad Mallard Platform

Portable, open-source Docker Compose deployment for a shared business application platform.

## Applications and roadmap
- Matomo — web analytics
- Supabase — backend platform
- Metabase — business intelligence
- Chatwoot — customer support
- n8n — workflow automation
- Horilla — HR management
- Authentik — identity and access management
- Homepage — application portal

## Design requirements
- One primary `compose.yaml` and an `.env.example`.
- Reuse database engines, Redis and infrastructure only where upstream software supports it; isolate databases, accounts and data.
- Preserve vendor-supported Supabase services and dependencies.
- Support deployment to any compatible Docker Compose host without fixed host IPs.
- Integrate with an existing Traefik, monitoring and backup stack without duplicating those services.
- Provide optional standalone deployment prerequisites and clear configuration.
- Support shared branding and SSO where upstream applications allow it; document limitations.
- Use supported, pinned container versions; never commit secrets.
- Include validation, tests, security checks, backup/restore instructions and operational runbooks.

> Status: Docker Compose currently deploys Matomo, Metabase, Chatwoot (web and worker), n8n, and Horilla, backed by PostgreSQL, MariaDB, and Redis. Supabase, Authentik, and Homepage remain planned. Production readiness and single sign-on are not yet complete.

## Local operations

Copy `.env.example` to `.env`, replace all example secrets, and run `docker compose config --quiet` before `docker compose up -d`. Run `bash scripts/audit-runtime.sh` to report missing, stopped, or unhealthy Compose services without modifying them. A service without a Docker healthcheck is reported as `not-configured`, not proven healthy.

Never run `docker compose down -v` unless you intend to delete persistent application data.


## Licensing
The original orchestration, scripts and documentation in this repository are MIT licensed. Referenced third-party applications and container images retain their own respective licenses and trademark rights. See [LICENSE](LICENSE).
