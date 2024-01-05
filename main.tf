terraform {
  cloud {
  hostname = "app.terraform.io"
  organization = "Test-Abhinav"
  workspaces {
    name = "Create-AWS-EC2-VCS"
  }
}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.65.0"
    }
  }
}
resource "null_resource" "null-tfcws"{
count = var.number_of_instances
}
provider "aws" {
  region = "us-west-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name      = "Hello-World-VCS"
    workspace = terraform.workspace
  }
}
