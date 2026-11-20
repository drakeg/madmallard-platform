# Security

Do not publish credentials, real `.env` files, or database ports. Keep applications loopback-bound by default; LAN access requires a trusted network, firewall, appropriate authentication and application URL/CSRF configuration. Review container tags and vulnerabilities before upgrades. Preserve data and take tested backups before consequential migrations. Report vulnerabilities privately to repository maintainers rather than opening issues with exploit details.
