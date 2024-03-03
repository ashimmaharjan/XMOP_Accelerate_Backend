variable "region" {
  type    = string
  default = "ap-southeast-2"
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
  type    = string
  default = "wordpress"
}

variable "instance_bundleid" {
  type    = string
  default = "small_3_2"
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
