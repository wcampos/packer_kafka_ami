.PHONY: all init validate build clean docker-build docker-test docker-clean docker-shell

# Default AWS profile, can be overridden with make build AWS_PROFILE=other-profile
AWS_PROFILE ?= personal

# Default region, can be overridden with make build REGION=other-region
REGION ?= us-east-1

all: init validate build

init:
	@echo "Initializing Packer plugins..."
	packer init kafka.pkr.hcl

validate:
	@echo "Validating Packer configuration..."
	AWS_PROFILE=$(AWS_PROFILE) packer validate kafka.pkr.hcl

build:
	@echo "Building Kafka AMI using AWS profile: $(AWS_PROFILE) in region: $(REGION)..."
	AWS_PROFILE=$(AWS_PROFILE) packer build -var="region=$(REGION)" kafka.pkr.hcl

clean:
	@echo "Cleaning up temporary files..."
	rm -rf packer_cache/
	rm -f *.log

# Docker testing targets
docker-build:
	@echo "Building Docker test environment..."
	docker compose build

docker-test:
	@echo "Running Ansible playbook in Docker container..."
	docker compose up --abort-on-container-exit

docker-clean:
	@echo "Cleaning up Docker resources..."
	docker compose down -v
	docker compose rm -f

docker-shell:
	@echo "Opening shell in Docker container..."
	docker compose run --rm kafka-ami-test /bin/bash

help:
	@echo "Available targets:"
	@echo "  make init          - Initialize Packer plugins"
	@echo "  make validate      - Validate the Packer configuration"
	@echo "  make build         - Build the Kafka AMI"
	@echo "  make clean         - Clean up temporary files"
	@echo "  make all           - Run init, validate, and build"
	@echo ""
	@echo "Docker testing targets:"
	@echo "  make docker-build  - Build the Docker test environment"
	@echo "  make docker-test   - Run Ansible playbook in Docker"
	@echo "  make docker-shell  - Open a shell in the Docker container"
	@echo "  make docker-clean  - Clean up Docker resources"
	@echo ""
	@echo "Variables:"
	@echo "  AWS_PROFILE       - AWS profile to use (default: personal)"
	@echo "  REGION           - AWS region to build in (default: us-east-1)"
	@echo ""
	@echo "Examples:"
	@echo "  make build AWS_PROFILE=prod REGION=us-west-2"
	@echo "  make docker-test  # Test Ansible playbook locally" 