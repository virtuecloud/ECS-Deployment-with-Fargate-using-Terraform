resource "aws_ecs_service" "example-ecs-service" {
  name = var.ecs_service_name
  cluster = var.cluster_arn
  task_definition = aws_ecs_task_definition.example_task_def.arn
  launch_type = "FARGATE"
  desired_count = var.ecs_desired_count
  # depends_on = [aws_cloudwatch_log_group.example_cw_log_group]
  
  load_balancer {
    target_group_arn = module.alb.target_group_arns[0]
    container_name = var.ecs_service_name
    container_port = var.container_port
  }
  
  network_configuration {
    subnets = var.priv_subnet_ids
    # subnets = [module.vpc.private_subnets[0],module.vpc.private_subnets[1]]
    security_groups = [module.ecs-sg.security_group_id]
  }
}