# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a collection of self-hosted Docker Compose service stacks for development and infrastructure environments. Each top-level directory is an independent stack, all sharing a common external Docker network (`local-network`) that allows inter-service communication.

## Shared Infrastructure Pattern

All stacks depend on an external `local-network` Docker network. Create it once before starting any stack:
```sh
docker network create local-network
```

All services bind to `127.0.0.1` by default (not `0.0.0.0`), overridable via `*_BIND_ADDRESS` env vars. Each stack has its own `.env` file (copy from `.env.example` if present).

## Service Stacks

### `supabase/` — Full Supabase self-hosted stack

The most complex stack. Uses `run.sh` as its management script and supports composable override files.

**Key commands (run from `supabase/`):**
```sh
sh run.sh start                        # docker compose up -d --wait
sh run.sh stop                         # docker compose down
sh run.sh restart [service]            # restart one or all services
sh run.sh recreate [service]           # force-recreate (down then up)
sh run.sh restart --except <svc>...    # restart all except named
sh run.sh status                       # docker compose ps
sh run.sh logs [service]               # follow logs
sh run.sh inspect <service>            # docker inspect on a service's container
sh run.sh printenv <service>           # print a service's environment variables
sh run.sh pull                         # pull all images
sh run.sh config                       # show active compose file list
sh run.sh config add <name>            # add an override (e.g. pg17, nginx, caddy)
sh run.sh config remove <name>         # remove an override
sh run.sh compose-config               # dump fully-resolved compose config
sh run.sh secrets                      # show key passwords and API keys
sh reset.sh                            # full teardown, wipe data, reset .env
```

**Bootstrap from scratch:**
```sh
sh setup.sh                            # interactive setup (installs Docker, generates keys)
sh setup.sh -y --project-dir my-dir   # non-interactive, named directory
```

**Compose override files** (add via `sh run.sh config add <name>`):
- `pg17` — PostgreSQL 17 instead of default PG 15
- `nginx` — nginx with Let's Encrypt TLS termination in front of Kong
- `caddy` — Caddy with automatic HTTPS in front of Kong
- `envoy` — Envoy as API gateway alternative to Kong
- `s3` — MinIO-backed S3 storage backend instead of local filesystem
- `rustfs` — RustFS storage backend

**Service architecture:**
- `studio` — Supabase Dashboard UI (port varies)
- `kong` — API gateway (ports `KONG_HTTP_PORT` / `KONG_HTTPS_PORT`)
- `auth` — GoTrue authentication service
- `rest` — PostgREST REST API
- `realtime` — WebSocket realtime subscriptions
- `storage` — File storage API + imgproxy
- `meta` — postgres-meta API for schema management
- `functions` — Deno Edge Functions runtime
- `analytics` — Logflare analytics (postgres backend by default, BigQuery optional)
- `db` — Supabase Postgres 15 (supabase/postgres image with extensions)
- `vector` — Log aggregation/forwarding to analytics
- `supavisor` — Postgres connection pooler (ports `POSTGRES_PORT` / `POOLER_PROXY_PORT_TRANSACTION`)

**Key utilities (in `supabase/utils/`):**
```sh
sh utils/generate-keys.sh --update-env        # regenerate JWT secret + API keys
sh utils/add-new-auth-keys.sh --update-env    # generate asymmetric EC key pair + opaque keys
sh utils/rotate-new-api-keys.sh --update-env  # rotate opaque API keys
sh utils/db-passwd.sh --update-env            # rotate DB password
sh utils/upgrade-pg17.sh                      # upgrade existing PG15 data to PG17
sh utils/reassign-owner.sh                    # fix object ownership after migrations
```

**Tests (in `supabase/tests/`):**
```sh
sh tests/test-self-hosted.sh         # smoke test a running stack
sh tests/test-s3-backend.sh          # verify S3/MinIO storage backend
sh tests/test-auth-keys.sh           # verify JWT/API key configuration
sh tests/test-pg17-upgrade.sh        # verify PG17 upgrade
sh tests/test-container-logs.sh      # verify log pipeline
```

**Configuration reference:** `supabase/CONFIG.md` contains the full environment variable reference for every service. `supabase/versions.md` tracks image version history.

---

### `monitoring-stack/` — Prometheus + Grafana observability

Scrapes metrics from all other stacks on the shared `local-network`.

```sh
cd monitoring-stack && docker compose up -d
```

Components: Prometheus (`:9090`), Alertmanager (`:9093`), Grafana (`:3000`), Loki (`:3100`), Promtail, Node Exporter (`:9100`), cAdvisor (`:8081`).

Prometheus is pre-configured to scrape exporters from: MySQL, Postgres (pgadmin stack), MLflow Postgres, Redis, RabbitMQ, MinIO (both stacks), Vault, and Supabase cloud metrics.

---

### `postgres-pgadmin/` — Standalone Postgres + pgAdmin

- Postgres 15.6 on port `POSTGRES_BIND_ADDRESS:5432` (default `127.0.0.1:5432`)
- pgAdmin on `PGADMIN_BIND_ADDRESS:8888` (default `127.0.0.1:8888`)
- Includes a `postgres-exporter` sidecar for Prometheus metrics
- Init scripts in `init/` run at first startup

---

### `mysql-phpmyadmin/` — MySQL + phpMyAdmin

- MySQL 8.0.36 on port `MYSQL_BIND_ADDRESS:3306`
- phpMyAdmin on `PHPMYADMIN_BIND_ADDRESS:8080`
- Includes a `mysqld-exporter` sidecar for Prometheus metrics
- Init scripts in `init/` run at first startup

---

### `mlflow/` — MLflow experiment tracking

- MLflow server on `MLFLOW_BIND_ADDRESS:5000` backed by Postgres + MinIO
- Postgres 15.6 on `POSTGRES_BIND_ADDRESS:5432` (internal, for MLflow metadata)
- MinIO on `MINIO_BIND_ADDRESS:9000` / `MINIO_CONSOLE_BIND_ADDRESS:9001` (artifact storage)
- Bucket `mlflow` is created automatically at startup by the `create-bucket` init service
- Network alias `mlflow-minio` allows the monitoring stack to distinguish it from the standalone MinIO

---

### `redis-service/` — Redis + RedisInsight

- Redis 7 on `REDIS_BIND_ADDRESS:6379` with persistence (AOF + RDB)
- RedisInsight UI on `REDIS_INSIGHT_BIND_ADDRESS:5540`
- Includes `redis-exporter` sidecar for Prometheus metrics

---

### `rabbitmq-service/` — RabbitMQ

- RabbitMQ 3 with Management, MQTT, Web-MQTT, and Prometheus plugins enabled
- Ports: AMQP `5672`, Management UI `15672`, MQTT `1883`, Web-MQTT `15675`
- Pre-loaded definitions from `definitions.json`

---

### `minio/` — Standalone MinIO (AIStor enterprise edition)

- Requires a `./data/minio.license` file placed before startup
- MinIO API on `MINIO_BIND_ADDRESS:9000`, Console on `MINIO_CONSOLE_BIND_ADDRESS:9001`
- Data persisted to `./data/minio-data/`
- TLS certs (optional) placed in `./data/minio-certs/`

---

### `vault/` — HashiCorp Vault

- Vault on `VAULT_BIND_ADDRESS:8200` (default `127.0.0.1:8200`)
- Runs with TLS; CA cert expected at `./userconfig/tls/ca.crt`
- Config in `./config/vault-config.hcl`; data persisted in `./data/`
- Audit logs in `./audit/`

## Common Operations

```sh
# Start any stack
cd <stack-dir> && docker compose up -d

# View logs for a specific service
docker compose logs -f <service>

# Rebuild after .env changes (no downtime for other services)
docker compose up -d --force-recreate --no-deps <service>

# Check all running containers across stacks
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```
