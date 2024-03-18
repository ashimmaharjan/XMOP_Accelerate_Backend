

resource "aws_instance" "binod" {
  ami           = "ami-09ccb67fcbf1d625c"
  instance_type = "t2.micro"
  key_name      = "binodkey"

 // user_data     = file("userdata/install_wordpress.sh")

  tags = {
    Name = "WordPressInstance"
  }

  lifecycle {
    create_before_destroy = true
  }
}

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
  } 
}
}

