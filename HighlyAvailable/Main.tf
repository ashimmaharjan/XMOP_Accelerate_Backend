//create VPC 
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = "true"  #gives internal domain name
  enable_dns_hostnames = "true" #gives internal host name
  instance_tenancy = "default"
}

//Create IGW for internet Connection..
resource "aws_internet_gateway" "my-igw"{
  vpc_id = aws_vpc.my_vpc.id 
}

//creating route table
resource "aws_route_table" "public-route"{
  vpc_id = aws_vpc.my_vpc.id

  route {
    //associated subnet can reach anywhere
    cidr_block = "0.0.0.0/0"
    //Route uses this IGW to reach internet
    gateway_id = aws_internet_gateway.my-igw.id
  }
}

//Associating route table to public subnet
resource "aws_route_table_association" "my-crta-public-subnet-1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-route.id
}

# Create RDS instance....
//We associate above subnet group with our database instance
resource "aws_db_instance" "wordpressdb" {
  allocated_storage = 10
  engine = var.db_type
  engine_version = var.engine_version
  instance_class = var.db_engine_class
  publicly_accessible = "true"
  db_name = var.database_name
  identifier = "mydb"
  username = var.database_username
  password = var.database_password
  vpc_security_group_ids = [aws_security_group.RDS-sg-group.id]
  db_subnet_group_name = aws_db_subnet_group.my_db_subnet_group.id
  skip_final_snapshot = true
  multi_az = var.multi_az
  # make sure rds manual password chnages is ignored
  lifecycle {
     ignore_changes = [password]
   }

}


// create ec2 instance (only after RDS is provisioned)...
/*
resource "aws_instance" "ec2_wordpress" {
  ami           = "ami-09ccb67fcbf1d625c"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public-subnet-1.id
  vpc_security_group_ids = ["${aws_security_group.ec2-sg-group.id}"]
  key_name      = "binodkey"

 // user_data     = file("userdata/install_wordpress.sh")

  tags = {
    Name = "WordPressInstance"
  }
}
*/
/*
# creating Elastic IP for EC2
resource "aws_eip" "eip" {
  instance = aws_autoscaling_group.my-auto-scale.id
}
*/
/*
resource "null_resource" "provision_instance" {
  depends_on = [aws_autoscaling_group.my-auto-scale]

 # Copy the script to the remote instance
  provisioner "file" {
    source      = "./userdata/install_wordpress.sh"
    destination = "/tmp/install_wordpress.sh"
    
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("C:\\Users\\binod\\Downloads\\binodkey.pem")
      host        = aws_autoscaling_group.my-auto-scale.id
      timeout = "20m"
    }
  }

  # Execute the script on the remote instance
 provisioner "remote-exec" {
  inline = [
     "chmod +x /tmp/install_wordpress.sh",
      "/tmp/install_wordpress.sh args",
  ]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("C:\\Users\\binod\\Downloads\\binodkey.pem")
    host        = aws_autoscaling_group.my-auto-scale.id
    timeout = "20m"
  } 
}
}
*/




