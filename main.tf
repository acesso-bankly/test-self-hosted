terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.26.0"
    }
  }

  required_version = ">= 1"
}

provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

/* data "aws_ami" "ubuntu_server" {
  most_recent = true
  owners      = [data.aws_caller_identity.current.account_id]
  filter {
    name = "name"
    values = [
      "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20200407",
    ]
  }
} */

data "aws_security_group" "security_group" {
    filter { 
        name = "group-name"
        values = ["github-actions-github-actions-runner-sg20221025200509814500000001"]
    }

    filter {
        name = "vpc-id"
        values = ["vpc-00935567e29c67234"]
    }
}


resource "aws_instance" "ultimate_github_runner" {
  vpc_security_group_ids = [data.aws_security_group.security_group.id]
  ami                    = "ami-08c40ec9ead489470"
  instance_type          = "t2.micro" ## Free tier
  user_data              = templatefile("scripts/ec2.sh", { personal_access_token = var.personal_access_token })
  tags = {
    Name = "GitHub-Runner"
    Type = "terraform"
  }
}