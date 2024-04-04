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

//resource for creating keypair.......
resource "null_resource" "create_key_pair" {
  # Use a null resource as a trigger for local-exec provisioner
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "python ${path.module}/create_key_pair.py ${var.key_name}"
  }
}

//creating ec2 instance for wordpress....
resource "aws_instance" "wordpress_instance" {
  ami           = var.ami
  instance_type = var.instance
  key_name      = var.key_name
  subnet_id = aws_subnet.public-subnet-1.id
  vpc_security_group_ids = [aws_security_group.wordress-sg.id]
  user_data = data.template_file.userdata_script.rendered

  root_block_device {
    volume_size           = var.storage_size  # Specify the volume size in GB
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = {
    Name = "WordPressInstance"
  }

  lifecycle {
    create_before_destroy = true
  }

}

data "template_file" "userdata_script" {
  template = file("${path.module}/userdata/install_wordpress.sh.tpl")

  vars = {
    db_name          = var.database_name
    db_username      = var.database_username
    db_password      = var.database_password
    php_version      = var.php_version
    apache_version   = var.apache_version
    db_type          = var.db_type
  }
}



/*
resource "null_resource" "provision_instance" {
  depends_on = [aws_instance.binod]

 # Copy the script to the remote instance
  provisioner "file" {
    source      = "./userdata/install_wordpress.sh"
    destination = "/tmp/install_wordpress.sh"


    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("C:\\Users\\binod\\Downloads\\binodkey.pem")
      host        = aws_instance.binod.public_ip
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
    host        = aws_instance.binod.public_ip
    timeout = "20m"
  } 
}
}

*/