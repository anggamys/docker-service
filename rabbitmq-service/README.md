# RabbitMQ Service

## Overview

RabbitMQ is a **message broker** that implements the **Advanced Message Queuing Protocol (AMQP)**.
It enables decoupling between applications and services by providing a **reliable, scalable, and fault-tolerant** messaging infrastructure.

RabbitMQ supports multiple messaging protocols, including **AMQP** and **MQTT**, making it highly flexible for system integration.

## Running the Service

Start RabbitMQ using **Docker Compose**:

```bash
docker-compose up -d
```

Once running, RabbitMQ exposes the following endpoints:

* **Management UI (Web Dashboard)** → [http://localhost:15672](http://localhost:15672)
* **MQTT Service** → `localhost:1883`

Default credentials for the Management UI (unless changed in `docker-compose.yml`):

* Username: `guest`
* Password: `guest`

## Testing the Service

### 1. Test with MQTT (using Mosquitto)

#### Subscribe to a topic:

```bash
mosquitto_sub -h localhost -t "test/topic"
```

#### Publish a message to the topic:

```bash
mosquitto_pub -h localhost -t "test/topic" -m "Hello World!"
```

If configured correctly, the subscriber should receive the message `"Hello World!"`.
