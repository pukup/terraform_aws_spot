data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_spot_instance_request" "cheap" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  spot_price                  = "0.004"
  subnet_id                   = aws_subnet.subnet.id
  vpc_security_group_ids      = [aws_security_group.allow_tcp.id]

  user_data                   = file("install_apache.sh")

  tags = {
    Name = "cheap"
  }
}
