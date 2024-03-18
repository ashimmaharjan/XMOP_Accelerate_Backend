output "public_instance_ip" {
  value = aws_instance.wordpress_instance.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.mysql.endpoint
}
output "rds_username" {
  value = aws_db_instance.mysql.username
}

output "rds_name" {
  value = aws_db_instance.mysql.db_name
}
