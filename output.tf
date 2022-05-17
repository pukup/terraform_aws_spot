output "web_instance_public_ip"{
    value = aws_spot_instance_request.cheap.public_ip
}
