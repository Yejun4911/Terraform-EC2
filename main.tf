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

# Jenkins-
# resource "aws_instance" "jenkins_server" {
#   ami             = var.ami
#   instance_type   = var.instance_type
#   # subnet_id       = module.subnet.subnet_id
#   # security_groups = [module.security_group.sg_id]
# 
#   user_data = <<-EOF
#               #!/bin/bash
#               sudo yum update -y
#               sudo yum install -y java-11-openjdk
#               sudo wget -O /etc/yum.repos.d/jenkins.repo \
#                 https://pkg.jenkins.io/redhat-stable/jenkins.repo
#               sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
#               sudo yum install -y jenkins
#               sudo systemctl enable jenkins
#               sudo systemctl start jenkins
#               EOF
# 
#   tags = {
#     Name = "Jenkins-Server"
#   }
# }
}
