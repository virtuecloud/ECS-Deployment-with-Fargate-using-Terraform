resource "aws_ecs_service" "ecs-service" {
  name = var.ecs_service_name
  cluster = var.cluster_arn
  task_definition = aws_ecs_task_definition.task_def.arn
  launch_type = "FARGATE"
  desired_count = var.ecs_desired_count
  health_check_grace_period_seconds = var.health_check_grace_period_seconds
  lifecycle {
    ignore_changes = [task_definition]
  }
  
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs-ip-tg.arn
    container_name = "${var.ecs_service_name}"
    container_port = var.container_port
  }
  
  network_configuration {
    subnets = var.priv_subnet_ids
    security_groups = [module.ecs-sg.security_group_id]
  }
  tags = var.tags
  propagate_tags = "SERVICE"
}