resource "aws_vpc" "vpc" {
  cidr_block = "172.31.0.0/16"

  tags = {
    Name = "vpc"
  }
}
resource "aws_subnet" "public-a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "172.31.1.0/24"

  availability_zone       = data.aws_availability_zone.a.name
  map_public_ip_on_launch = true

  tags = {
    Name = "public"
  }
}
resource "aws_subnet" "public-b" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "172.31.4.0/24"

  availability_zone       = data.aws_availability_zone.b.name
  map_public_ip_on_launch = true

  tags = {
    Name = "public"
  }
}
resource "aws_subnet" "public-c" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "172.31.3.0/24"

  availability_zone       = data.aws_availability_zone.c.name
  map_public_ip_on_launch = true

  tags = {
    Name = "public"
  }
}
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "172.31.2.0/24"

  tags = {
    Name = "private"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "gw"
  }
}
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "route_table"
  }
}
resource "aws_route_table" "route_table_private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.example.id
  }
  tags = {
    Name = "route_table_private"
  }
}
resource "aws_eip" "ngw" {
  vpc      = true
}
resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.ngw.id
  subnet_id     = aws_subnet.public-a.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public-a.id
  route_table_id = aws_route_table.route_table.id
}
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.public-b.id
  route_table_id = aws_route_table.route_table.id
}
resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.public-c.id
  route_table_id = aws_route_table.route_table.id
}
resource "aws_route_table_association" "d" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.route_table_private.id
}
# prepare subnets with azs and with load balancer and nat gateway to private network
# health checks in lb

resource "aws_lb" "test_lb" {
  name               = "test-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_tcp_80.id]
  subnets            = [aws_subnet.public-a.id, aws_subnet.public-b.id, aws_subnet.public-c.id]

  enable_deletion_protection = false 

  tags = {
    Name = "test_lb"
  }
}
resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}
resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.test.arn
  target_id        = aws_instance.free.id
  port             = 80
  depends_on       = [aws_instance.free]
}
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test_lb.arn
  port              = "80"
  protocol          = "HTTP"
  ##  ssl_policy        = "ELBSecurityPolicy-2016-08"
  ##  certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}
resource "aws_security_group" "allow_tcp_80" {
  name        = "allow_tcp_80"
  description = "Allow TCP protocol at port 80"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow implemented as ticket 001"
    from_port   = 80
    to_port     = 80
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
    Name = "allow_tcp_80"
  }
}
resource "aws_security_group" "allow_from_load_balancer" {
  name        = "allow_from_load_balancer"
  description = "Allow only from load_balancer"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow implemented as ticket 001"
    from_port   = 80
    to_port     = 80
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
    Name = "allow_from_load_balancer"
  }
}
