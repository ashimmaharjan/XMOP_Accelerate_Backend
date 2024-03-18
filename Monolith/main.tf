resource "aws_instance" "wordpress_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.ec2_public_subnet.id
  vpc_security_group_ids = [aws_security_group.wordpress_instance-sg.id]
  key_name               = var.key_name
  user_data              = file("install_scripts.sh")
  tags = {
    Name = "Wordpress instance"
  }
  depends_on = [
    aws_db_instance.mysql,
  ]
}

resource "aws_db_instance" "mysql" {
  identifier              = "wordpressdb-instance"
  allocated_storage       = 10
  engine                  = "mysql"
  engine_version          = "8.0.36"
  instance_class          = "db.t3.micro"
  db_name                 = var.db_name
  username                = var.db_user
  password                = var.db_password
  backup_retention_period = 7
  multi_az                = false
  availability_zone       = var.availability_zone[1]
  db_subnet_group_name    = aws_db_subnet_group.database_subnet.id
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.database-sg.id]
  storage_encrypted       = true
  tags = {
    Name = "Wordpressdb_instance"
  }
}
