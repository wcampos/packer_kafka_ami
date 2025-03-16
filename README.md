# Kafka Base AMI Builder

This Packer configuration creates a base AMI for Apache Kafka using Amazon Linux 2023 as the base operating system.

[![Test Ansible Playbook](https://github.com/wcampos/packer_kafka_ami/actions/workflows/test-ansible.yml/badge.svg)](https://github.com/wcampos/packer_kafka_ami/actions/workflows/test-ansible.yml)
[![Test Packer Configuration](https://github.com/wcampos/packer_kafka_ami/actions/workflows/test-packer.yml/badge.svg)](https://github.com/wcampos/packer_kafka_ami/actions/workflows/test-packer.yml)
[![Create Release](https://github.com/wcampos/packer_kafka_ami/actions/workflows/release.yml/badge.svg)](https://github.com/wcampos/packer_kafka_ami/actions/workflows/release.yml)

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

## Continuous Integration

This project uses GitHub Actions for continuous integration:

- **Ansible Testing**: Automatically tests the Ansible playbook in a Docker container
- **Packer Validation**: Validates the Packer configuration syntax and structure
- **Automated Releases**: Creates timestamped releases with packaged code

The workflows are triggered on:
- Push to master branch
- Pull requests to master branch
- Changes to relevant files (playbooks, Packer configs)

### Releases

Releases are automatically created when changes are pushed to the master branch. Each release includes:
- A timestamp-based version tag (e.g., v20240316_120530)
- A ZIP file containing all necessary files to build the AMI
- Automatically generated release notes

You can find all releases in the [Releases](https://github.com/wcampos/packer_kafka_ami/releases) section.

## Notes

This Packer configuration creates a base AMI with Kafka dependencies installed. The actual Kafka and Zookeeper configuration should be done during instance deployment (e.g., using Terraform).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
