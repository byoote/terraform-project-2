resource "aws_ami_from_instance" "app_server_ami" {
  name               = "utcappserver"
  source_instance_id = aws_instance.app_server["0"].id

  tags = {
    Name = "utcappserver"
    env  = "dev"
    team = "config management"
}
}