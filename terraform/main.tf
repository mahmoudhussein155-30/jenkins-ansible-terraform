provider "aws" {
  region = var.aws_region
}

resource "aws_key_pair" "deployer" {
  key_name   = "jenkins-key"
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Allow SSH and HTTP"

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

resource "aws_instance" "ubuntu_ec2" {
  ami           = "ami-053b0d53c279acc90" # Ubuntu 22.04 (us-east-1)
  instance_type = "t2.micro"

  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  tags = {
    Name = "Ubuntu-Ansible-Server"
  }
}
