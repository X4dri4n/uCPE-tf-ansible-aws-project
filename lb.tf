#Creating the application loadbalancer
resource "aws_lb" "net-lb" {
  provider           = aws.ucpe
  name               = "ws-lb"
  internal           = true
  load_balancer_type = "application"
  #enable_cross_zone_load_balancing = true
  security_groups = [aws_security_group.lb-sg.id]
  subnets         = [aws_subnet.subnet_2.id, aws_subnet.subnet_3.id]

  tags = {
    Name = "ws-lb"
  }
}

#Create the target group for loadbalancer
resource "aws_lb_target_group" "net-lb-tg" {
  provider    = aws.ucpe
  name        = "net-lb-tg"
  port        = var.ws-port
  target_type = "instance"
  vpc_id      = aws_vpc.vpc_ucpe.id
  protocol    = "HTTP"
  stickiness {
    type    = "lb_cookie"
    enabled = false
  }
  health_check {
    enabled  = true
    interval = 10
    path     = "/"
    port     = var.ws-port
    protocol = "HTTP"
    matcher  = "200-299"
  }
  tags = {
    Name = "ws-tg"
  }
}

#Create the http listener
resource "aws_lb_listener" "ws-listener-http" {
  provider          = aws.ucpe
  load_balancer_arn = aws_lb.net-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.net-lb-tg.arn
  }
}

#Create target group attachments
resource "aws_lb_target_group_attachment" "ws-vm1-attach" {
  provider         = aws.ucpe
  target_group_arn = aws_lb_target_group.net-lb-tg.arn
  target_id        = aws_instance.ws-vm1.id
  port             = var.ws-port
}

resource "aws_lb_target_group_attachment" "ws-vm2-attach" {
  provider         = aws.ucpe
  target_group_arn = aws_lb_target_group.net-lb-tg.arn
  target_id        = aws_instance.ws-vm2.id
  port             = var.ws-port
}
