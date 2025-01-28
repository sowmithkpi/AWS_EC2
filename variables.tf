variable "region" {
    default = "ca-central-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "destination_cidr_block" {
    default = "0.0.0.0/0"
}

variable "ami" {
    default = "ami-06aff9380bf1f3b54"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "ingress_from_port" {
    default = "80"
}

variable "ingress_to_port" {
    default = "80"
}

variable "ingress_cidr_blocks" {
    default = "0.0.0.0/0"
}

variable "egress_from_port" {
    default = "0"
}

variable "egress_to_port" {
    default = "0"
}

variable "egress_cidr_blocks" {
    default = "0.0.0.0/0"
}


