# Authelia

SSO server with Traefik reverse proxy. File-based authentication, TOTP, SQLite storage.

## Setup

```bash
cp .env.example .env
# Edit .env

# Generate self-signed SSL cert
docker run --rm -v "$(pwd)/traefik/certs:/tmp/certs" authelia/authelia \
  authelia crypto certificate rsa generate --common-name="*.example.com" --directory=/tmp/certs/

# Create user
docker run --rm authelia/authelia authelia crypto hash generate argon2 --password "yourpassword"

# Update authelia/users_database.yml with username, displayname, and hashed password
# Update authelia/configuration.yml with your domain

docker compose up -d
```

## Access

- `https://authelia.example.com` — Authelia portal
- `https://traefik.example.com` — Traefik dashboard (protected by Authelia)

Add to `/etc/hosts`:
```
127.0.0.1 authelia.example.com traefik.example.com
```
