provider "aws" {
  region = "ap-northeast-2"
}

# # VPC 생성
# module "vpc" {
#   source   = "../modules/vpc"
#   vpc_cidr = "10.0.0.0/16"
#   name = "dev-dooribun-vpc-apne2"
# }
#
# # 보안 그룹 생성
module "security_group" {
  source = "../modules/security-group"
  # vpc_id = module.vpc.vpc_id
}

# # 서브넷 생성
# module "subnet" {
#   source            = "../modules/subnet"
#   vpc_id           = module.vpc.vpc_id
#   subnet_cidr      = "10.0.1.0/24"
#   availability_zone = "ap-northeast-2a"
#   public_ip        = true
#   name = "dev-pub-jenkins-subnet"
# }

resource "aws_key_pair" "my_key" {
  key_name   = "my-key"
  public_key = file("~/ssh/jenkins-key.pub")
}
resource "aws_instance" "jenkins_server" {
  ami             = var.ami
  instance_type   = var.instance_type
  key_name = aws_key_pair.my_key.key_name
  # subnet_id       = module.subnet.subnet_id
  vpc_security_group_ids = [module.security_group.sg_id]

  user_data = <<-EOF
              #!/bin/bash
              set -e

              # Java 설치
              sudo dnf install -y java-17-amazon-corretto

              # Jenkins 레포 등록
              sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
              # sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
              sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io-2023.key
              # Jenkins 설치
              sudo dnf install -y jenkins

              # Jenkins 서비스 실행
              sudo systemctl enable jenkins
              sudo systemctl start jenkins
              EOF

  tags = {
    Name = "jenkins-server"
  }
}

output "jenkins_public_ip" {
  value = aws_instance.jenkins_server.public_ip
}
