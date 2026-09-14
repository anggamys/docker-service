# Docker Service

A collection of self-hosted Docker Compose services.

## Services

| Folder | Service |
|---|---|
| `9router/` | 9Router + Headroom |
| `authelia/` | Authelia SSO + Traefik reverse proxy |
| `minio/` | MinIO — S3-compatible object storage |
| `mlflow/` | MLflow — ML experiment tracking + MinIO + PostgreSQL |
| `monitoring-stack/` | Prometheus, Grafana, Loki, Alertmanager, cAdvisor |
| `kafka/` | Apache Kafka 4.0 (KRaft, no ZooKeeper) |
| `mysql-phpmyadmin/` | MySQL + phpMyAdmin |
| `postgres-pgadmin/` | PostgreSQL + pgAdmin |
| `redis/` | Redis + RedisInsight |
| `supabase/` | Supabase (self-hosted) |

## Usage

Each service has its own `.env` file (git-ignored). Copy `.env.example` to `.env` and edit.

```bash
cd <service>
cp .env.example .env
# Edit .env with your values
docker compose up -d
```
