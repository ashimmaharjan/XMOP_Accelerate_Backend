variable "inbound_port_production_ec2" {
  type        = list(any)
  default     = [22, 80]
  description = "inbound port allow on production instance"
}

variable "availability_zones" {
  type    = list(string)
  default = ["ap-southeast-2a", "ap-southeast-2b"]
}

variable "target_application_port" {
  type    = string
  default = "80"
}

variable "aws_region" {
  type    = string
  default = "ap-southeast-2"
}

variable "min_instances" {
  type    = number
  default = 2
}

variable "max_instances" {
  type    = number
  default = 5
}

variable "ami" {
  type    = string
  default = "ami-081ab858da818bcf1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type    = string
  default = "wordpressKey"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}


variable "storage_size" {
  type    = number
  default = 20
}

variable "db_engine" {
  type    = string
  default = "mysql"
}

variable "engine_version" {
  type    = string
  default = "5.7"
}

variable "db_instance_type" {
  type    = string
  default = "db.t3.micro"
}

variable "db_name" {
  type    = string
  default = "wordpressdb"
}

variable "db_user" {
  type    = string
  default = "admin"
}

variable "db_password" {
  type    = string
  default = "Wordpress-AWS2Tier"
}

variable "storage_capacity" {
  type    = number
  default = 20
}

variable "subnet_cidrs" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  description = "CIDR blocks for the EC2 and RDS subnets"
}




