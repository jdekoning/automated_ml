provider "aws" {
    profile    = "playground"
    region     = var.region
}

resource "aws_vpc" "default" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
}

resource "aws_internet_gateway" "default" {
    vpc_id = aws_vpc.default.id
}

resource "aws_security_group" "vpc_sg" {
    name = "vpc_sg"
    description = "Security group used by the VPC ACL."

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = var.allowed_cidrs
    }

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = aws_vpc.default.id
}

/*
  Public Subnet
*/
resource "aws_subnet" "eu-west-1a-public" {
    vpc_id = aws_vpc.default.id

    cidr_block = var.public_subnet_cidr
    availability_zone = var.availability_zone
}

resource "aws_route_table" "eu-west-1a-public" {
    vpc_id = aws_vpc.default.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.default.id
    }
}

resource "aws_route_table_association" "eu-west-1a-public" {
    subnet_id      = aws_subnet.eu-west-1a-public.id
    route_table_id = aws_route_table.eu-west-1a-public.id
}
