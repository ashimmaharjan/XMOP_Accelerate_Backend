variable "region" {
  type = string
}

variable "availability_zone" {
  type    = list(string)
  default = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2d"]
}

variable "instance" {
  type    = string
  default = "Wordpress-Instance"
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

variable "static_ip" {
  type    = string
  default = "Wordpress-IP"
}

variable "static_ip_attachment" {
  type    = string
  default = "Wordpress-IP"
}
