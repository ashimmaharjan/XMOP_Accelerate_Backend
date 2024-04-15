//To place RDS instances in VPC subnets in AWS, you would need to create RDS Subnet groups. 
//A subnet group is a group of subnets where we can create and manage database instances
resource "aws_db_subnet_group" "my_db_subnet_group" {
  name = "my-db-subnet-group"
  subnet_ids = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]

  tags = {
    Name = "My DB Subnet Group"
  }
}