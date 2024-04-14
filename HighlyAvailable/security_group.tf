resource "aws_security_group" "highlyavailable_instance_sg" {
  name        = "highlyavailable_instance_sg"
  description = "Security group for EC2 instances"
  vpc_id      = aws_vpc.highlyavailable_vpc.id

  # dynamic block who create two rules to allow inbound traffic 
  dynamic "ingress" {
    for_each = var.inbound_port_production_ec2
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "database-sg" {
  name        = "database-sg"
  description = "Security group for RDS"
  vpc_id      = aws_vpc.highlyavailable_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.highlyavailable_instance_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}
