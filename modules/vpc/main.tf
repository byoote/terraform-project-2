# terraform_project/modules/vpc/main.tf


resource "aws_vpc" "utc_vpc" {
  cidr_block       = "10.10.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "utc-vpc"
    env  = "dev"
    team = "config management"
  }
}