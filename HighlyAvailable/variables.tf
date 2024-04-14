variable "inbound_port_production_ec2" {
  type        = list(any)
  default     = [22, 80]
  description = "inbound port allow on production instance"
}

variable "instance_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "target_application_port" {
  type    = string
  default = "80"
}

variable "min_instances" {
  type = number
}

variable "max_instances" {
  type = number
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}


variable "storage_size" {
  type = number
}

variable "db_engine" {
  type = string
}

variable "engine_version" {
  type = string
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

variable "multi_az" {
  type = bool
}




