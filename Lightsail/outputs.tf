output "instance_ip" {
  value = aws_lightsail_static_ip.static_ip.ip_address
}

output "instance_arn" {
  value = aws_lightsail_instance.instance.arn
}
