provider "aws" {
  region = var.region
}

resource "aws_key_pair" "deployer" {
  key_name   = "jenkins-key"
  public_key = file(var.public_key_path)
}

resource "aws_instance" "jenkins_ec2" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = aws_key_pair.deployer.key_name

  tags = {
    Name = "jenkins-ec2"
  }
}
