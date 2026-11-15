#!/usr/bin/env bash
# Read-only checks for browser-facing applications on a private LAN.
set -euo pipefail
cd "$(dirname "$0")/.."
python3 - <<'PY'
import ipaddress, os, pathlib, re, sys
lines = pathlib.Path('.env').read_text().splitlines() if pathlib.Path('.env').exists() else []
settings = {}
for line in lines:
    if re.match(r'^[A-Za-z_][A-Za-z_0-9]*=', line):
        key, value = line.split('=', 1)
        settings[key] = value.strip().strip('"').strip("'")
apps = {'Matomo': ('MATOMO', 8088), 'Metabase': ('METABASE', 3003), 'n8n': ('N8N', 5678), 'Chatwoot': ('CHATWOOT', 3004), 'Horilla': ('HORILLA', 8000)}
lan = 0
for name, (prefix, port) in apps.items():
    bind = settings.get(prefix + '_BIND_IP', '127.0.0.1')
    port = settings.get(prefix + '_PORT', str(port))
    try:
        address = ipaddress.ip_address(bind)
        scope = 'LAN-capable' if address.is_unspecified or address.is_private and not address.is_loopback else 'loopback-only'
    except ValueError:
        scope = 'hostname (verify manually)'
    lan += scope == 'LAN-capable'
    print(f'{name:10} {bind}:{port:6} {scope}')
print('\nThis checks configured bindings only, not firewall, authentication, or remote connectivity.')
if not lan:
    print('All applications are currently restricted to local access.')
PY
