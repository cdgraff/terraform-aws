variable "profile" {
  default = "default"
}

variable "region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami" {
  default = "ami-0323c3dd2da7fb37d"
}
variable "alb_name" {
  
}
variable "alb_target_group_name" {
  default = "aferrari-webservers"
}

variable "listener_port" {
  default = 80  
}
variable "listener_protocol" {
  default = "HTTP"
}

