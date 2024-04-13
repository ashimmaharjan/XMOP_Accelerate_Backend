output "public_ips" {
  value       = [for instance in aws_instance.highlyavailable_instance : instance.public_ip]
  description = "Public IPs of the highlyavailable instances"
}


output "rds_endpoint" {
  value = aws_db_instance.rds_master.endpoint
}
output "rds_username" {
  value = aws_db_instance.rds_master.username
}

output "rds_name" {
  value = aws_db_instance.rds_master.db_name
}

output "lb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.application_loadbalancer.dns_name
}
