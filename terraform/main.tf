provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "jenkins_sg" {
  name = "jenkins_sg"

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

resource "aws_instance" "jenkins_ec2" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"
  key_name      = "sec"

  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  tags = {
    Name = "jenkins-ec2"

  user_data = <<-EOF
              #!/bin/bash
              # Install Python 3.9
              amazon-linux-extras enable python3.9
              yum install -y python3.9 python3.9-venv python3.9-pip
              EOF
  }
}
