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


data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id

  instance_type = "t3.micro"
  key_name      = "sec"

  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

user_data = <<-EOF
  #!/bin/bash
  # Update OS
  yum update -y

  # Enable Python 3.9 extra and install it
  amazon-linux-extras enable python3.9 -y
  yum install -y python3.9 python3.9-venv python3.9-pip

  # Make sure python3 points to python3.9
  alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 2
EOF

  tags = {
    Name = "jenkins-ec2"



  }
}
