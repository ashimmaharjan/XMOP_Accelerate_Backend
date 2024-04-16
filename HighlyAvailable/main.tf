resource "aws_instance" "highlyavailable_instance" {
  count           = var.max_instances
  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = count.index % 2 == 0 ? aws_subnet.ec2_1_public_subnet.id : aws_subnet.ec2_2_public_subnet.id
  key_name        = var.key_name
  user_data       = file("install_script.sh")
  security_groups = [aws_security_group.highlyavailable_instance_sg.id]
  root_block_device {
    volume_size = var.storage_size
    volume_type = "gp2"
  }
  tags = {
    Name = "${var.instance_name}-${count.index}"
  }
}

resource "aws_db_instance" "rds_master" {
  allocated_storage    = var.storage_capacity
  engine               = var.db_engine
  engine_version       = var.engine_version
  instance_class       = var.db_instance_type
  identifier           = "my-rds-master"
  db_name              = var.db_name
  username             = var.db_user
  password             = var.db_password
  multi_az             = var.multi_az
  db_subnet_group_name = aws_db_subnet_group.database_subnet.id
  availability_zone    = data.aws_availability_zones.available.names[0]
  skip_final_snapshot  = true
  tags = {
    Name = "my-rds-master"
  }
}

