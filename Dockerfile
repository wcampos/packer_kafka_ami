FROM amazonlinux:2023

# Install system dependencies
RUN dnf update -y && \
    dnf install -y \
    sudo \
    python3 \
    python3-pip \
    shadow-utils \
    tar \
    gzip \
    && dnf clean all

# Install Ansible
RUN python3 -m pip install ansible

# Create a test user with sudo privileges
RUN useradd -m -s /bin/bash testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/testuser

# Set working directory
WORKDIR /ansible

# Copy Ansible playbook and related files
COPY RemoteFiles /ansible/RemoteFiles/

# Switch to test user
USER testuser

# Command to run Ansible playbook
CMD ["ansible-playbook", "-i", "localhost,", "--connection=local", "RemoteFiles/packer_install/main.yaml"] 