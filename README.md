# Mad Mallard Platform

[![Compose validation](https://github.com/drakeg/madmallard-platform/actions/workflows/validate.yml/badge.svg)](https://github.com/drakeg/madmallard-platform/actions/workflows/validate.yml) [![Shell checks](https://github.com/drakeg/madmallard-platform/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/drakeg/madmallard-platform/actions/workflows/shellcheck.yml) [![License](https://img.shields.io/github/license/drakeg/madmallard-platform)](LICENSE)
[![Docker Compose](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)](compose.yaml) [![PostgreSQL](https://img.shields.io/badge/PostgreSQL-17-4169E1?logo=postgresql&logoColor=white)](compose.yaml) [![MariaDB](https://img.shields.io/badge/MariaDB-configured-003545?logo=mariadb&logoColor=white)](compose.yaml) [![Redis](https://img.shields.io/badge/Redis-configured-DC382D?logo=redis&logoColor=white)](compose.yaml) [![Python](https://img.shields.io/badge/Python-smoke_tests-3776AB?logo=python&logoColor=white)](scripts/check-http-health.py)
[![Latest release](https://img.shields.io/github/v/release/drakeg/madmallard-platform?display_name=tag)](https://github.com/drakeg/madmallard-platform/releases) [![Issues](https://img.shields.io/github/issues/drakeg/madmallard-platform)](https://github.com/drakeg/madmallard-platform/issues) [![Pull requests](https://img.shields.io/github/issues-pr/drakeg/madmallard-platform)](https://github.com/drakeg/madmallard-platform/pulls)


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

Copy `.env.example` to `.env`, replace all example secrets, and run `docker compose config --quiet` before `docker compose up -d`. Run `python3 scripts/check-http-health.py` to probe the five browser-facing applications from the Docker host without altering data. HTTP checks can succeed for login/setup pages and do not prove full application health. Run `bash scripts/audit-runtime.sh` to report missing, stopped, or unhealthy Compose services without modifying them. A service without a Docker healthcheck is reported as `not-configured`, not proven healthy.

Never run `docker compose down -v` unless you intend to delete persistent application data.


For access from other computers, see [LAN deployment guidance](docs/local-network.md) and run `bash scripts/check-lan-readiness.sh` before changing any network bindings.

## Licensing
The original orchestration, scripts and documentation in this repository are MIT licensed. Referenced third-party applications and container images retain their own respective licenses and trademark rights. See [LICENSE](LICENSE).
