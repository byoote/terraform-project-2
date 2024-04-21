# terraform_project/main.tf

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name = "utc-vpc"
  cidr = "10.10.0.0/16"
  azs  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  
  private_subnets = [
    "10.10.1.0/24",
    "10.10.2.0/24",
    "10.10.3.0/24",
    "10.10.4.0/24",
    "10.10.5.0/24",
    "10.10.6.0/24"
  ]
  public_subnets = [
    "10.10.101.0/24",
    "10.10.102.0/24",
    "10.10.103.0/24"
  ]
enable_nat_gateway = true
  single_nat_gateway = false
  one_nat_gateway_per_az = true


  tags = {
    Name = "utc-vpc"
    env  = "dev"
    team = "config management"}
}
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP and HTTPS"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
 to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    env  = "dev"
    team = "config management"
}
}



