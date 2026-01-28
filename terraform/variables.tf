variable "region" {
  default = "us-east-1"
}

variable "public_key_path" {
  default = "../sec.pub"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "ami" {
  default = "ami-0dba2cb6798deb6d8" # Ubuntu 22.04 LTS in us-east-1
}
