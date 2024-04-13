output "public_ips" {
  value = [for instance in aws_instance.wordpress_instance : instance.public_ip]
}