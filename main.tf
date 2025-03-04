terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.29.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_instance" "EC2-TEST" {
  ami                   = "ami-0ea766b7a13aecc49"
  instance_type         = "t4g.micro"
  tags = {
    Name = "ExampleAppServerInstance"
  }
}
