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

variable "db_type" {
  default = "mariadb-server"
}

variable "allow_ssh"{
  default = "false"
}

variable "allow_http"{
  default = "true"
}

variable "key_name"{
  default = "mykey"
}

variable "storage_size" {
  default = "30"
}

variable "apache_version"{
  default = "httpd"
}

variable "php_version"{
  default = "php8.0"
}
