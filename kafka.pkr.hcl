packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1.2.8"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1.1.1"
    }
  }
}

variable "region" {
  type    = string
  default = "us-east-1"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "kafka" {
  ami_name        = "Kafka_Base_AL2023-${local.timestamp}"
  ami_description = "Kafka Amazon Linux 2023 AMI"
  instance_type   = "t3.micro"
  region          = var.region
  
  source_ami_filter {
    filters = {
      name                = "al2023-ami-2023.*-x86_64"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }

  ssh_username = "ec2-user"

  tags = {
    Name       = "Kafka_Base_AL2023-${local.timestamp}"
    OS_Version = "Amazon Linux 2023"
    Release    = local.timestamp
  }
}

build {
  sources = ["source.amazon-ebs.kafka"]

  provisioner "shell" {
    inline = [
      "sudo dnf update -y",
      "sudo dnf install -y ansible"
    ]
  }

  provisioner "ansible-local" {
    playbook_file = "./RemoteFiles/packer_install/main.yaml"
  }
} 