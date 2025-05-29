# Docker Service

## Description

This repository provides database services using Docker Compose, including MySQL with PhpMyAdmin and PostgreSQL with PgAdmin, designed for easy local development and testing.

## Installation

### 1. Fork and Clone the Repository

First, fork this repository to your GitHub account, then clone it to your local machine:

```bash
git clone git@github.com:anggamys/docker-service.git
cd docker-service
```

> Replace `<username>` with your GitHub username and `<repository>` with the name of the forked repository.

## Usage

### 1. Navigate to the Project Directory

```bash
cd docker-service
```

> Replace `<repository>` with the name of the cloned project folder.

### 2. Choose the Service You Want to Use

- `mysql-phpmyadmin`
- `postgresql-pgadmin`

Navigate into the selected service directory:

```bash
cd mysql-phpmyadmin
# or
cd postgresql-pgadmin
```

### 3. Copy and Configure the Environment File

Copy the `.env` example file:

```bash
cp .env.example .env
```

Then edit the `.env` file according to your needs. You can configure:

- Username
- Password
- Database name
- Access port

> The `.env` file is used by Docker Compose to manage service configuration.

### 4. Start the Service

Run the following command to build and start the containers in the background:

```bash
docker-compose up -d
```

> This command will build and launch the containers in detached mode.

### 5. Access the Services

Once the services are up and running, access them via your browser using the configured ports:

- **MySQL & PhpMyAdmin**

  - PhpMyAdmin: [http://localhost:8080](http://localhost:8080)
  - MySQL: `localhost:3307`

- **PostgreSQL & PgAdmin**

  - PgAdmin: [http://localhost:8081](http://localhost:8081)
  - PostgreSQL: `localhost:5432`

### 6. Stop the Services

To stop and remove the containers:

```bash
docker-compose down
```

> This will shut down and clean up the containers, networks, and volumes created by `docker-compose up`.
