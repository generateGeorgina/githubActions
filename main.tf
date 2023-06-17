provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "webserver" {
  ami           = "ami-0a6006bac3b9bb8d3"
  instance_type = "t2.micro"

  tags = {
    Name = "GeorginasHelloWorldWebServer"
  }

  user_data = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y git
    git clone git@github.com:generateGeorgina/githubActions.git
    cd githubActions
    cp index.html /var/www/html
    service apache2 start
    EOF
}

resource "aws_security_group" "webserver_sg" {
  name        = "webserver-sg"
  description = "Security group for the webserver instance"

    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

output "public_ip" {
  value = aws_instance.webserver.public_ip
}