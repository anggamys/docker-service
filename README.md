# Docker Service

A collection of self-hosted Docker Compose services, designed to run on both **local development** and **production** environments from a single codebase — no branch switching, no duplicate folders.

## Services

| Folder | Service |
|---|---|
| `minio/` | MinIO — S3-compatible object storage |
| `mlflow/` | MLflow — ML experiment tracking + MinIO + PostgreSQL |
| `monitoring-stack/` | Prometheus, Grafana, Loki, Alertmanager, cAdvisor |
| `mysql-phpmyadmin/` | MySQL + phpMyAdmin |
| `postgres-pgadmin/` | PostgreSQL + pgAdmin |
| `rabbitmq/` | RabbitMQ (AMQP + MQTT + Management UI) |
| `redis/` | Redis + RedisInsight |
| `supabase/` | Supabase (self-hosted) |
| `vault/` | HashiCorp Vault |

## Environment Setup

Each service uses a `.env.<env>` file to separate dev and prod configuration.

### 1. Copy the example file

```bash
# For local development
cp <service>/.env.example <service>/.env.dev

# For production
cp <service>/.env.example <service>/.env.prod
```

### 2. Edit the values

Key differences between environments:

| Variable | dev | prod |
|---|---|---|
| `*_BIND_ADDRESS` | `127.0.0.1` | `0.0.0.0` |
| Passwords / secrets | simple | long random string |
| Database name | `app_dev` | `app_prod` |

> **Note:** `.env.dev` and `.env.prod` are git-ignored and will never be committed.

## Usage

Use the `run.sh` helper script at the root:

```bash
# Start a single service
./run.sh <service> <env> [docker-compose-command] [options]

# Start postgres in dev
./run.sh postgres-pgadmin dev

# Start postgres in prod
./run.sh postgres-pgadmin prod

# Stop redis in dev
./run.sh redis dev down

# Follow logs for monitoring-stack in dev
./run.sh monitoring-stack dev logs -f

# Start ALL services that have .env.dev configured
./run.sh all dev

# Stop ALL services in prod
./run.sh all prod down
```

Or use Docker Compose directly:

```bash
cd <service>
docker compose --env-file .env.dev up -d   # dev
docker compose --env-file .env.prod up -d  # prod
```

## Quick Start (Development)

```bash
# 1. Clone the repo
git clone <repo-url>
cd docker-service

# 2. Setup a service (e.g. postgres)
cp postgres-pgadmin/.env.example postgres-pgadmin/.env.dev
# Edit postgres-pgadmin/.env.dev with your preferred values

# 3. Start it
./run.sh postgres-pgadmin dev
```
