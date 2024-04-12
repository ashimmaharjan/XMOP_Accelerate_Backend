output "public_ip" {
  value = aws_instance.wordpress_instance.public_ip
}

output "instance_arn" {
  value = aws_instance.wordpress_instance.arn
}
