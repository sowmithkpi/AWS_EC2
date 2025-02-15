provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Interview-VPC"
  }
}

resource "aws_subnet" "public_subnets" {
  count = length(data.aws_availability_zones.available.names)
  
  vpc_id         = aws_vpc.main.id
  cidr_block     = element(var.public_subnet_cidr_blocks, count.index) 
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true 
  
  tags = {
    Name = "public-subnet-${count.index}"
  }
}

resource "aws_subnet" "private_subnets" {
  count = length(data.aws_availability_zones.available.names)
  vpc_id = aws_vpc.main.id  
  cidr_block = element(var.private_subnet_cidrs, count.index)
  map_public_ip_on_launch = false
  availability_zone = element(data.aws_availability_zones.available.names, count.index) 
  tags = {
    Name = "Private Subnet ${count.index}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Interview-IGW"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Public-Route-Table"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = var.destination_cidr_block
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_subnet_association" {
  count = length(data.aws_availability_zones.available.names)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "nginx_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = var.ingress_from_port 
    to_port     = var.ingress_to_port   
    protocol    = "tcp"
    cidr_blocks = [var.ingress_cidr_blocks] 
  }

  egress {
    from_port   = var.egress_from_port 
    to_port     = var.egress_from_port  
    protocol    = "-1"
    cidr_blocks = [var.egress_cidr_blocks] 
  }

  tags = {
    Name = "Nginx-SG"
  }
}

resource "aws_instance" "web_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id                   = aws_subnet.public_subnets[1].id
  vpc_security_group_ids      = [aws_security_group.nginx_sg.id]

    tags = {
    Name = "Nginx-Instance"
  }
}