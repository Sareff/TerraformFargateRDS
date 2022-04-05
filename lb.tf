resource "aws_security_group" "sg-app-lb-task-2" {
  name   = "security-group-app-lb-task-2"
  vpc_id = aws_vpc.vpc-task-2.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Http for web-app"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "all"
    to_port     = 0
  }
}

resource "aws_lb" "app-lb-task-2" {
  name               = "app-lb-task-2"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg-app-lb-task-2.id]
  subnets            = [aws_subnet.public-a-task-2.id, aws_subnet.public-b-task-2.id]
}

resource "aws_lb_target_group" "app-lb-tg-task-2" {
  name        = "app-lb-tg-task-2"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc-task-2.id

  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "app-lb-ltnr-task-2" {
  load_balancer_arn = aws_lb.app-lb-task-2.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-lb-tg-task-2.arn
  }
}