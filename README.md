# Mad Mallard Platform

Portable, open-source Docker Compose deployment for a shared business application platform.

## Planned applications
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

> Status: Initial repository setup. The complete stack is not yet implemented or deployable.

## Licensing
The original orchestration, scripts and documentation in this repository are MIT licensed. Referenced third-party applications and container images retain their own respective licenses and trademark rights. See [LICENSE](LICENSE).
