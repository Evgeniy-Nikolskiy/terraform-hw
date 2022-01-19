terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.72.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
  token = var.provider_token
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20211129"]
  }
}

locals {
  web_instance_type_map = {
    stage = "t3.micro"
    prod  = "t3.large"
  }
  web_instance_count_map = {
    stage = 1
    prod  = 2
  }
  instances = {
    "t3.micro" = data.aws_ami.ubuntu.id
    "t3.large" = data.aws_ami.ubuntu.id
  }
}
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "single-instance"

  ami                    = "data.aws_ami.ubuntu.id"
  instance_type          = "t3.micro"
  key_name               = "user-terr-hw"
  monitoring             = true
  vpc_security_group_ids = ["sg-12345678"]
  subnet_id              = "subnet-eddcdzz4"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}