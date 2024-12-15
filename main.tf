provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow inbound/outbound traffic"

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
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_instance" {
  ami           = "ami-0453ec754f44f9a4a"
  instance_type = "t2.micro"
  key_name      = "EC2FirstInstance"

  security_groups = [aws_security_group.web_sg.name]

  user_data = <<-EOF
              #!/bin/bash

              sudo yum update -y
              sudo yum install docker -y
              sudo service docker start
              sudo usermod -aG docker ec2-user
              newgrp docker

              docker run --detach --publish 80:80 --name plain-web-app m567/plain-web-app-image
              docker run -detach --name watchtower -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --interval 10 --cleanup

              EOF

  tags = {
    Name = "Lab 2 WebInstance"
  }
}

