resource "aws_instance" "bastion_host" {
  ami           = "ami-0c2b8ca1dad447f8a"  # Update this to the latest Amazon Linux AMI in your region
  instance_type = "t2.micro"
  key_name      = aws_key_pair.utc_key.key_name
  subnet_id     = module.vpc.public_subnets[0]  # Assuming first public subnet

  vpc_security_group_ids = [
    aws_security_group.bastion_host_sg.id,
  ]

  tags = {
    Name = "bastion-host"
    env  = "dev"
    team = "config management"
  }
}

resource "aws_security_group" "bastion_host_sg" {
  name        = "bastion-host-sg"
  description = "Security group for bastion host"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["YOUR_IP_ADDRESS/32"]
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