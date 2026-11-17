#!/usr/bin/env python3
"""Read-only local HTTP smoke checks; no third-party dependencies."""
import argparse
import os
from pathlib import Path
import sys
import urllib.error
import urllib.request

APPS = {
    'matomo': ('MATOMO', '8088', '/'),
    'metabase': ('METABASE', '3003', '/api/health'),
    'n8n': ('N8N', '5678', '/healthz'),
    'chatwoot': ('CHATWOOT', '3004', '/'),
    'horilla': ('HORILLA', '8000', '/login/'),
}

def read_env(path):
    result = {}
    if path.exists():
        for raw in path.read_text().splitlines():
            if not raw or raw.lstrip().startswith('#') or '=' not in raw:
                continue
            key, value = raw.split('=', 1)
            result[key.strip()] = value.strip().strip('"').strip("'")
    return result

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--env-file', type=Path, default=Path(__file__).resolve().parent.parent / '.env')
    parser.add_argument('--timeout', type=float, default=5)
    parser.add_argument('--host', default='127.0.0.1', help='Host reachable from the machine running this script')
    args = parser.parse_args()
    if args.timeout <= 0:
        parser.error('--timeout must be positive')
    config = read_env(args.env_file)
    failed = False
    for name, (prefix, default_port, path) in APPS.items():
        port = config.get(prefix + '_PORT', default_port)
        url = f'http://{args.host}:{port}{path}'
        try:
            request = urllib.request.Request(url, headers={'User-Agent': 'MadMallard-HealthCheck/1.0'})
            opener = urllib.request.build_opener(urllib.request.ProxyHandler({}), urllib.request.HTTPRedirectHandler())
            with opener.open(request, timeout=args.timeout) as response:
                status = response.status
            healthy = status < 500
            print(f'{"OK" if healthy else "FAIL"} {name:10} HTTP {status} {url}')
            failed |= not healthy
        except urllib.error.HTTPError as exc:
            # Login and initial-setup pages can require authentication.
            healthy = exc.code in (401, 403, 404)
            print(f'{"OK" if healthy else "FAIL"} {name:10} HTTP {exc.code} {url}')
            failed |= not healthy
        except (urllib.error.URLError, TimeoutError, ValueError, OSError) as exc:
            print(f'FAIL {name:10} {type(exc).__name__} {url}')
            failed = True
    print('HTTP smoke checks test responsiveness, not full app functionality or authentication.')
    return int(failed)

if __name__ == '__main__':
    sys.exit(main())
