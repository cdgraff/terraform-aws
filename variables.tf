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
  default = "ami-085925f297f89fce1"
}
variable "alb_name" {
  
}
variable "listener_port" {
  default = 80  
}
variable "listener_protocol" {
  default = "HTTP"
}


