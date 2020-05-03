resource "aws_lb" "alb" {  
  name            = var.alb_name
  load_balancer_type = "application"
  subnets         = [aws_subnet.aferrari-subnet-1-public.id,aws_subnet.aferrari-subnet-2-public.id]
  security_groups = [aws_security_group.alb.id]
  internal        = false  
  idle_timeout    = 30   
}

resource "aws_alb_target_group" "alb_target_group" {  
  name     = var.alb_target_group_name
  port     = var.listener_port
  protocol = var.listener_protocol  
  vpc_id   = aws_vpc.aferrari-vpc.id   

  health_check {    
    healthy_threshold   = 3    
    unhealthy_threshold = 10    
    timeout             = 5    
    interval            = 10    
    path                = "/"
    port                = var.listener_port
  }
}


resource "aws_alb_listener" "alb_listener" {  
  load_balancer_arn = aws_lb.alb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  
  default_action {    
    target_group_arn = aws_alb_target_group.alb_target_group.arn
    type             = "forward"  
  }
}