terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


resource "aws_security_group" "sonarqube" {
  name   = "SonarQube dashboard"
  vpc_id = var.vpc_id


  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical
# }

data "aws_ami" "sonarqube" {
  most_recent = true

  filter {
    name   = "image-id"
    values = ["ami-005f9685cb30f234b"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

resource "aws_instance" "sonarqube" {
  ami           = data.aws_ami.sonarqube.id
  instance_type = "t2.medium" #4GB RAM

  key_name = "aws"

  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.sonarqube.id, var.ssh_sg_id]
  associate_public_ip_address = true

  user_data = <<-EOF
  #!/bin/bash
  yum update -y
  sudo yum install -y java-17-amazon-corretto
  sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.0.65466.zip -O /opt/sonarqube.zip
  sudo unzip /opt/sonarqube.zip -d /opt
  sudo useradd -m -G wheel sonarqube
  sudo chown -R sonarqube:sonarqube /opt/sonarqube*
  sudo -H -u sonarqube bash -c '/opt/sonar*/bin/linux-x86-64/sonar.sh start' 
  EOF
  tags = {
    Name = "sonarqube-daszkiewiczk"
  }
}
