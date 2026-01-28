provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "jenkins_ec2" {
  ami           = "ami-0c02fb55956c7d316"   # Amazon Linux 2
  instance_type = "t2.micro"
  key_name      = "your-key-name"

  tags = {
    Name = "jenkins-ec2"
  }
}

output "public_ip" {
  value = aws_instance.jenkins_ec2.public_ip
}
