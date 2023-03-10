terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_vpc" "vpc-a" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "subnet-a" {
  vpc_id     = aws_vpc.vpc-a.id
  cidr_block = var.subnet_cidr

  tags = {
    Name = var.subnet_name
  }
}

resource "aws_internet_gateway" "gw-a" {
  vpc_id = aws_vpc.vpc-a.id

  tags = {
    Name = var.igw_name
  }
}
resource "aws_route_table" "rt-a" {
  vpc_id = aws_vpc.vpc-a.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw-a.id
  }

  tags = {
    Name = var.igw_name
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-a.id
  route_table_id = aws_route_table.rt-a.id
}

resource "aws_security_group" "sg" {
  name   = "HTTP"
  vpc_id = aws_vpc.vpc-a.id


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
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
  instance_type = var.aws_instance_type

  key_name = aws_key_pair.aws-test.key_name

  subnet_id                   = aws_subnet.subnet-a.id
  vpc_security_group_ids      = [aws_security_group.sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
  #!/bin/bash
  sudo apt -y install nginx
  echo "<h1>henlo</h1>" | sudo tee /var/www/html/index.nginx-debian.html
  sudo systemctl enable --now nginx
  sudo ufw disable
  sudo apt-get install ec2-instance-connect
  EOF
  #note: change to user_data DOES NOT trigger recreation of aws_instance
  tags = {
    Name = var.webserver_name
  }
}

resource "aws_key_pair" "aws-test" {
  key_name   = "aws-test"
  public_key = file("id_rsa.pub")
}