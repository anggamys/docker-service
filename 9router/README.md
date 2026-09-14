# 9Router

9Router + Headroom (AI backend). Migrated from npm to Docker.

## Migration from npm

1. Stop the npm instance:
```bash
kill $(pgrep -f "9router/cli.js")
```

2. Copy your existing data:
```bash
cp .env.example .env
# Edit .env and set NINE_ROUTER_DATA_DIR to your existing ~/.9router path
```

3. Start with Docker:
```bash
docker compose up -d
```

Your existing `~/.9router/` data (database, auth, JWT secret) will be used directly.

## Fresh install

```bash
cp .env.example .env
docker compose up -d
```

## Access

- `http://127.0.0.1:20128` — 9Router UI
