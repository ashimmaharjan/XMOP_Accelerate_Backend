variable "region" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "instance" {
  type = string
}

variable "instance_blueprintid" {
  type = string
}

variable "instance_bundleid" {
  type = string
}

variable "intance_key_pair" {
  type    = string
  default = "Wordpress-KP"
}
