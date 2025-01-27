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

