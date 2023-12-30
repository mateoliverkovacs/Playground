terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.31.0"
    }
  }
}

provider "aws" {
  region  = "eu-north-1"
}

# --------------------------- VPC -------------------------------
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# ---------------------------SECURITY GROUP CREATION---------------------------
resource "aws_security_group" "mateoliverkovacs_SG" {
  name        = "mateoliverkovacs_SG"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC, port 443"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "mateoliverkovacs_SG"
  }
}

# ---------------------------DEFAULT SUBNET USAGE---------------------------
resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-west-2a"

  tags = {
    Name = "Default subnet for us-west-2a"
  }
}

# ---------------------------EC2 INSTANCE CREATION---------------------------
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"

  instance_type          = "t3.micro"
  ami                    = "ami-03643cf1426c9b40b"
  key_name               = "ubuntu"
  monitoring             = true
  vpc_security_group_ids = aws_security_group.mateoliverkovacs_SG
  subnet_id              = "subnet-0d59db081719c9210"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}