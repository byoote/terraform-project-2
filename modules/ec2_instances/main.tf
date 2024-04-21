resource "aws_instance" "app_server" {
  for_each      = { for idx, subnet in module.vpc.private_subnets : idx => subnet if idx < 2 }
  ami           = "ami-0c2b8ca1dad447f8a"  # Update this to the latest Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = aws_key_pair.utc_key.key_name
  subnet_id     = each.value

  vpc_security_group_ids = [
    aws_security_group.app_server_sg.id,
  ]

  user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install -y httpd.x86_64
                systemctl start httpd.service
                systemctl enable httpd.service
                echo “Hello World from $(hostname -f)”
            > /var/www/html/index.html
                EOF

  tags = {
    Name = "appserver-${each.key}"
    env  = "dev"
    team = "config management"
  }
}

resource "aws_security_group" "app_server_sg" {
  name        = "app-server-sg"
  description = "Security group for application servers"
  vpc_id      = module.vpc.vpc_id
# Define your ingress and egress rules similar to the bastion host
  # Ensure to reference security groups as sources where needed
}

# You should define alb_sg and database_sg with respective rules