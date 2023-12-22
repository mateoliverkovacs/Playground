terraform {
    cloud {
    organization = "mateoliverkovacs"

    workspaces {
      name = "Playground"
        }
    }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "eu-north-1"
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"

  instance_type          = "t3.micro"
  ami                    = "ami-0014ce3e52359afbd"
  key_name               = "user1"
  monitoring             = true
  vpc_security_group_ids = ["sg-0a8aec295d2868a18"]
  subnet_id              = "subnet-0d59db081719c9210"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}