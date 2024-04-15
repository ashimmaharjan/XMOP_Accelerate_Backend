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
  default = "t1.micro"
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
  default = "binodkey"
}

variable "storage_size" {
  default = "20"
}

variable "apache_version"{
  default = "httpd"
}

variable "php_version"{
  default = "php8.0"
}

variable "instance_name" {
  type = string
  default = "Binod"
}

variable "min_instance"{
  default = 1
}

variable "max_instance"{
  default = 5
} 

variable "engine_version"{
  default = "5.7"
}

variable "db_engine_class"{
  default = "db.t3.micro"
}

variable "multi_az"{
  default = "true"
}