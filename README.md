# Personal Docker Setup

This repository contains my personal Docker setup, including configurations for various services and applications that I use regularly. The goal is to have a consistent and reproducible environment across different machines.

## Services Included

- **MySQL + PhpMyAdmin**: A relational database management system along with a web interface for managing MySQL databases.
- **PostgreSQL + pgAdmin**: Another popular relational database system with a web-based administration tool.
- **RabbitMQ**: A message broker that facilitates communication between distributed systems.
- **Portainer**: A lightweight management UI which allows you to easily manage your Docker containers.
- **Janus Gateway**: A general purpose WebRTC server and gateway.
- **MinIO**: A high-performance, S3-compatible object storage service.

> For detailed configurations and usage instructions, please refer to the respective directories for each service.

## Getting Started

To get started with this setup, ensure you have Docker and Docker Compose installed on your machine. Then, clone this repository and navigate to its directory:

```bash
git clone https://github.com/anggamys/docker-service.git
cd docker-service
```

Move to specific service directory:

```bash
cd mysql-phpmyadmin
```

Start the services using Docker Compose:

```bash
docker compose up -d
```

This command will download the necessary Docker images and start the containers in detached mode.
You can check the status of the containers with:

```bash
docker compose ps
```

To stop the services, run:

```bash
docker compose down
```
