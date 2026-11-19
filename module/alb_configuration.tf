# ------------------------------------------------------------------------------
# Security Group for the Application Load Balancer
# ------------------------------------------------------------------------------
resource "aws_security_group" "alb" {
  name        = "${var.ecs_service_name}-alb-sg"
  description = "Security group for ALB - ${var.ecs_service_name}"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP traffic from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

# ------------------------------------------------------------------------------
# Application Load Balancer (ALB)
# ------------------------------------------------------------------------------
resource "aws_lb" "main" {
  name               = substr("${var.ecs_service_name}-alb", 0, 32)
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false

  tags = var.tags
}

# ------------------------------------------------------------------------------
# ALB Target Group
# ------------------------------------------------------------------------------
resource "aws_lb_target_group" "ecs-ip-tg" {
  name                              = "${substr(var.ecs_service_name, 0, 15)}-${var.env}"
  port                              = var.container_port
  protocol                          = "HTTP"
  target_type                       = "ip"
  vpc_id                            = var.vpc_id
  load_balancing_cross_zone_enabled = true

  lifecycle {
    create_before_destroy = true
  }

  health_check {
    enabled             = true
    interval            = 30
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 6
    protocol            = "HTTP"
    matcher             = "200-499"
  }

  tags = var.tags
}

# ------------------------------------------------------------------------------
# ALB HTTP Listener
# Default action forwards incoming HTTP traffic directly to the ECS Target Group
# ------------------------------------------------------------------------------
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs-ip-tg.arn
  }

  tags = var.tags
}

# ------------------------------------------------------------------------------
# Optional Host Header Listener Rule (if host header routing is specified)
# ------------------------------------------------------------------------------
resource "aws_lb_listener_rule" "static" {
  count        = (var.host != "" && var.host != "*") ? 1 : 0
  listener_arn = var.listener_arn != "" ? var.listener_arn : aws_lb_listener.http.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs-ip-tg.arn
  }

  condition {
    host_header {
      values = [var.host]
    }
  }

  tags = var.tags
}
