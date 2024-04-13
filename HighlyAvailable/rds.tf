# RDS Subnet Group
resource "aws_db_subnet_group" "database_subnet" {
  name = "rdsdbsubnet"
  subnet_ids = [aws_subnet.ec2_1_public_subnet.id,
    aws_subnet.ec2_2_public_subnet.id,
    aws_subnet.database_private_subnet.id
  ]
  tags = {
    Name = "database-subnet-group"
  }
}
