# Kafka Base AMI Builder

This Packer configuration creates a base AMI for Apache Kafka using Amazon Linux 2023 as the base operating system.

## Included Software

- **Operating System:** Amazon Linux 2023
- **Java:** Amazon Corretto 17
- **Kafka:** 3.9.0 (Scala 2.13)

## Prerequisites

- Packer >= 1.9.0
- AWS credentials configured
- Ansible (for local provisioning)
- Docker and Docker Compose (for local testing)

## Usage

1. Initialize Packer plugins:
```bash
packer init kafka.pkr.hcl
```

2. Build the AMI:
```bash
packer build kafka.pkr.hcl
```

## Local Testing with Docker

You can test the Ansible deployment locally using Docker:

1. Build the Docker test environment:
```bash
make docker-build
```

2. Run the Ansible playbook in Docker:
```bash
make docker-test
```

3. For interactive testing, open a shell in the container:
```bash
make docker-shell
```

4. Clean up Docker resources:
```bash
make docker-clean
```

## Configuration

- The AMI is configured with optimized memory settings for Kafka (512MB max heap, 256MB initial heap)
- Java environment variables are automatically configured
- The Kafka installation is located in `/opt/kafka`

## Notes

This Packer configuration creates a base AMI with Kafka dependencies installed. The actual Kafka and Zookeeper configuration should be done during instance deployment (e.g., using Terraform).
