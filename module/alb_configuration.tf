resource "aws_lb_target_group" "ecs-ip-tg" {
    name        = "${substr(var.ecs_service_name, 0, 15)}-${var.env}"
    # name        = "${var.ecs_service_name}-tg"
    port        = var.container_port
    protocol    = "HTTP"
    target_type = "ip"
    vpc_id      = var.vpc_id
    # load_balancing_cross_zone_enabled = var.load_balancing_cross_zone_enabled
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
      matcher  = "200-499"
    }

    tags = var.tags
}

resource "aws_lb_listener_rule" "static" {
  listener_arn = var.listener_arn
  # priority     = var.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs-ip-tg.arn
  }

  condition {
    host_header {
      values = ["${var.host}"]
    }
  }
  tags = var.tags
}