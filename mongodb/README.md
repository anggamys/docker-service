# MongoDB

MongoDB Community 8.0 + Mongo Express web UI.

## Setup

```bash
cp .env.example .env
# Edit .env if you want to change the Mongo Express default credentials

docker compose up -d
```

## Test MongoDB

```bash
docker exec -it mongodb mongosh --quiet --eval "db.runCommand({ ping: 1 })"
```

Harus menampilkan:

```json
{ ok: 1 }
```

## Mongo Express

Buka: `http://127.0.0.1:8081`

Login default:

```text
Username: admin
Password: change_me  # dari .env.example
```

## Development Notes

- Data disimpan di `./data/mongodb/` di host (persisten)
- Aplikasi lain di `local-network` bisa mengakses MongoDB melalui: `mongodb:27017`
- Untuk development lokal, gunakan Community image (bukan Enterprise Kubernetes Operator)

## Perubahan Port

- MongoDB: `127.0.0.1:27017` (host) → 27017 (container)
- Mongo Express: `127.0.0.1:8081` (host) → 8081 (container)
