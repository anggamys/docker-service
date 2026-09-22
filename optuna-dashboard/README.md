# Optuna Dashboard

Web UI untuk melihat hasil experiment Optuna. Membaca database SQLite di `./data/db.sqlite3`.

```bash
cp .env.example .env
docker compose up -d
```

Dashboard: `http://127.0.0.1:8080`

## Catatan

- `./data/db.sqlite3` di-mount ke `/app/db.sqlite3` di dalam container
- Untuk multi-container, gunakan PostgreSQL sebagai backend Optuna, bukan SQLite
