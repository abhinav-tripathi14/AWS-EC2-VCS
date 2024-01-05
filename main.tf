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
data "tfe_workspace" "test" {
  name         = "Create-AWS-EC2-VCS"
  organization = "Test-Abhinav"
}

data "tfe_variables" "testvar" {
  workspace_id = data.tfe_workspace.test.id
}
locals {
  get_nullresource_count = [ for i in { for k, v in data.tfe_variables.testvar.variables: k => v.value  if v.name == "number_of_instances" } : i ][0]
}

variable "get_nullresource_count" {
  default = local.get_null_resource_count
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
