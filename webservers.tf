resource "aws_instance" "nginx-instance" {
  instance_type = var.instance_type
  vpc_security_group_ids = [ aws_security_group.webservers.id ]
  associate_public_ip_address = true
  user_data = file("user-data/nginx.txt")

  tags = {
    Name = "nginx"
  }

  ami = var.ami
  availability_zone = "${var.region}a"
  subnet_id = aws_subnet.aferrari-subnet-1.id
  
}

resource "aws_lb_target_group_attachment" "nginx_lb_target_group_attachment" {
  target_group_arn = aws_alb_target_group.alb_target_group.arn
  target_id        = aws_instance.nginx-instance.id
}

resource "aws_instance" "apache-instance" {
  instance_type = var.instance_type
  vpc_security_group_ids = [ aws_security_group.webservers.id ]
  associate_public_ip_address = true
  user_data = file("user-data/apache.txt")

  tags = {
    Name = "apache"
  }

  ami = var.ami
  availability_zone = "${var.region}b"
  subnet_id = aws_subnet.aferrari-subnet-2.id

}

resource "aws_lb_target_group_attachment" "apache_lb_target_group_attachment" {
  target_group_arn = aws_alb_target_group.alb_target_group.arn
  target_id        = aws_instance.apache-instance.id
}