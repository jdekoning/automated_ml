variable "aws_key_name" {
  default = "toxicity"
}

variable "region" {
  default = "eu-west-1"
}

variable "availability_zone" {
  default = "eu-west-1a"
}

variable "ami" {
  # That's ekholabs private AMI which already contains all the dependencies needed.
  # This AMi is private. In order to speed-up the creation of your image, I advise to
  # Create you own AMI based on the AWS one, as I did.
  #default = "ami-f391058a"

  # That's the AWS Deep Learning AMI (Ubuntu 18.04) used along the GPU instance and compliant with
  # NVIDIA Drivers NVIDIA-Docker.
  default = "ami-03594fa02ff7c25e1"
}

variable "instance_type" {
  default = "g3.4xlarge"
}

variable "allowed_cidrs" {
  default = ["77.166.107.102/32"]
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.0.0.0/24"
}
