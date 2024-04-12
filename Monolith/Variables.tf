variable "instance_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "subnet_availability_zone" {
  type = string
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
  type = string
}

variable "instance_type" {
  type = string
}

variable "db_type" {
  type = string
}

variable "allow_ssh" {
  type = bool
}

variable "allow_http" {
  type = bool
}

variable "key_name" {
  type = string
}

variable "storage_size" {
  type = string
}

variable "apache_version" {
  type = string
}

variable "php_version" {
  type = string
}
