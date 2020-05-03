# security groups

resource "aws_security_group" "alb" {

    vpc_id = aws_vpc.aferrari-vpc.id

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    //If you do not add this rule, you can not reach the ALB
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_security_group" "webservers" {

    vpc_id = aws_vpc.aferrari-vpc.id

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    //If you do not add this rule, you can not reach the Webservers from the ALB
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.alb.id]
    }
}
