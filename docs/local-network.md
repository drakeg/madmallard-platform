# Accessing the suite from other devices on your LAN

Run `bash scripts/check-lan-readiness.sh` to inspect current `.env` bindings without modifying containers. The default `127.0.0.1` binds browser-facing applications to the Docker host only.

For a **trusted private network**, set only the desired application's `*_BIND_IP` in your private `.env` to the Mac's LAN IPv4 address, then recreate that service with `docker compose up -d --no-deps <service>`. For example, `MATOMO_BIND_IP=192.168.1.20` binds Matomo to that host interface; the example address must be replaced with your actual LAN address. Do **not** publish PostgreSQL, MariaDB, or Redis ports. Avoid `0.0.0.0` unless you understand all connected interfaces and firewall rules.

Verify from a second device using `http://<mac-lan-ip>:<configured-port>` and restrict incoming connections with the host firewall. Enable application authentication and HTTPS through a trusted reverse proxy before use on untrusted networks. Docker Desktop port forwarding and host firewall behavior vary by operating system.

Some applications also need their external URL, allowed hosts, or CSRF origins updated: `N8N_HOST`, `N8N_WEBHOOK_URL`, `CHATWOOT_FRONTEND_URL`, `HORILLA_ALLOWED_HOSTS`, and `HORILLA_CSRF_TRUSTED_ORIGINS`. Update these only to actual reachable addresses. Changing bind IP alone does not guarantee login, callbacks, or webhooks work.

This guide intentionally does not automatically expose the suite or modify local credentials.
