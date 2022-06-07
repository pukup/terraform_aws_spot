output "web_instance_public_ip" {
  value = aws_spot_instance_request.cheap.private_ip
}
output "aws_lb_dns_name" {
  value = aws_lb.test_lb.dns_name
}
