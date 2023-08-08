# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = var.region
}

resource "aws_vpc" "datamart_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "datamart-vpc"
  }
  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_subnet" "datamart_subnet" {
  vpc_id = aws_vpc.datamart_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "primary_subnet"
  }
}

resource "aws_security_group" "allow_ssh" {
  name = "allow_ssh"
  vpc_id = aws_vpc.datamart_vpc.id

  ingress {
    from_port =0 
    to_port=0 
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_internet_gateway" "datamart_gw" {
  vpc_id = aws_vpc.datamart_vpc.id
}

resource "aws_route_table" "datamart_routetable" {
  vpc_id = aws_vpc.datamart_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.datamart_gw.id 
  }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id = aws_subnet.datamart_subnet.id
  route_table_id = aws_route_table.datamart_routetable.id
}

resource "aws_instance" "foo" {
  key_name = "datamart_key"
  ami = "ami-024e6efaf93d85776"
  instance_type = "t2.micro"


  credit_specification {
    cpu_credits = "unlimited"
  }
  subnet_id = aws_subnet.datamart_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  associate_public_ip_address = true
  user_data = <<EOF
#! /bin/bash
sudo apt update -y
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable" -y
sudo apt update -y
sudo apt-get install docker-ce -y
sudo systemctl start docker
sudo systemctl enable docker
sudo groupadd docker
sudo usermod -aG docker ubuntu
sudo docker pull lebesgel/desk1_datamart
sudo docker run -p 80:8080 -d lebesgel/desk1_datamart
EOF
}


