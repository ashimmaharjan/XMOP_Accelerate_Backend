
output "load_balancer_dns_name" {
  value = aws_lb.wordpress_load_balancer.dns_name
}

output "RDS-Endpoint" {
  value = aws_db_instance.wordpressdb.endpoint
}

