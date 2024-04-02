variable "aws_region" {
  default = "ap-southeast-2"
}

variable "database_name" {
  default = "wordpress_db"

}

variable "database_username" {
  default = "wordpress_user"

}

variable "database_password" {
  default = "your_password"
 
}

variable "ami" {
  default = "ami-09ccb67fcbf1d625c"
}

variable "instance" {
  default = "t2.micro"
}

variable "dbtype" {
  default = "mysql"
}

variable "allow_ssh"{
  default = "false"
}

variable "key_name"{
  default = "mykey"
}