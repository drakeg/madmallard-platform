# Matomo setup

Matomo is the first application service in the platform.

1. Copy `.env.example` to `.env` and replace all example passwords with unique random secrets.
2. Start the app and its database: `docker compose up -d matomo`.
3. Open `http://localhost:8088` on the Docker host, or adjust `MATOMO_PORT` in `.env`.
4. Complete the Matomo browser installer and configure the first administrator.
5. Confirm Matomo can connect to MariaDB with database `matomo`, user `matomo`, and host `mariadb`.

The HTTP port is deliberately bound to loopback by default. Do not change
`MATOMO_BIND_IP` to `0.0.0.0` on a public host without TLS, access
controls and a reverse proxy. Production Traefik integration is a later milestone.

The `matomo_data` and `mariadb_data` volumes must be included in backups.
Application updates and schema migrations should be tested on a copy first.
